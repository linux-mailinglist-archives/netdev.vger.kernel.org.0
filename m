Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1318C01E
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 20:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728282AbfHMSGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 14:06:32 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33976 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727491AbfHMSGb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 14:06:31 -0400
Received: by mail-pg1-f194.google.com with SMTP id n9so45436493pgc.1;
        Tue, 13 Aug 2019 11:06:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kFehO82jdCviGuf5R66JFrCXPio1ptY0lQw9PECP1l0=;
        b=DdrOiE/3bDKX6HraMJ2Su2YgXpBCfapfPisGFr8ZTZrUBOvQxyrizpUgjvGLH3bg2Y
         IGe20CEw3E8B6sues1yt8n+KKd8KYVB1IrC1K880wvZo3uGgl7jwo+hOpTCUtAMCM6YW
         Ohowm/FbaEW7yanjt8wQ2DoAAYlLZ4NeVkDnQn/RmSVBfeTGlz4/3BzxL4poDZIwZYCh
         6ekG9u6FkLIyM2P4kiGoSsylL3yrkJaPE0acjr6lDgZQOanlHaY89SRj1SpeReJTI6R5
         +/C7BOoHkwd3BodDiDNy6quyCVA2N7fj5uqgzjtEhY68JDBXnwGNPsw1Qttkio3vpa96
         fCgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=kFehO82jdCviGuf5R66JFrCXPio1ptY0lQw9PECP1l0=;
        b=P6Xw+9hmSQerntKAcTLqpuc8Da42kaFh6jUHDntTjyNSgjucgwr/EsZUd6suH3cxzY
         gMFaFu+X6Rt1AB6S9jtmwEQZHFLj8Tc+f3vuT/p8qR6TdLQcF83vsprMzvcBK9TnzcFe
         ZJCbbjABcceSREPx9cDmX1a7mhwwtf9TVDCSrt5YADoOSaHZa+QWaVomYXAoAGHcz5iT
         zJklfrKavZ5fOdCcKySKXu2CkFTV3lzx7KKsW5nWR2BHWcjM/Sg/M6dcEeY5oco3njji
         35HIHUkjusSoS5RyumWmHXih3i7ny1NDxSOQSNu3BT/kqpiw2SsEj6+VPpmOxvRmENyx
         VCPg==
X-Gm-Message-State: APjAAAU2N6615WqTIzBL1yf3C8exIV7R1HKBuOE+b0Jiblapd+u+oGqy
        cTBNR2ijRl5c4G3sszbVm1o=
X-Google-Smtp-Source: APXvYqyErYOUyieMcTl9zfTAjH4jfmnWT0Gp0FeXitOmr+LhRTnH2/Xo4/eAA+Re/FnrarLOrwtQyA==
X-Received: by 2002:a65:64c5:: with SMTP id t5mr36518218pgv.168.1565719591093;
        Tue, 13 Aug 2019 11:06:31 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id 65sm112487304pff.148.2019.08.13.11.06.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Aug 2019 11:06:30 -0700 (PDT)
Date:   Tue, 13 Aug 2019 11:06:28 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Felipe Balbi <felipe.balbi@linux.intel.com>
Cc:     netdev@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        "Christopher S . Hall" <christopher.s.hall@intel.com>
Subject: Re: [RFC PATCH 4/5] PTP: Add flag for non-periodic output
Message-ID: <20190813180628.GA4069@localhost>
References: <20190716072038.8408-1-felipe.balbi@linux.intel.com>
 <20190716072038.8408-5-felipe.balbi@linux.intel.com>
 <20190716163927.GA2125@localhost>
 <87k1ch2m1i.fsf@linux.intel.com>
 <20190717173645.GD1464@localhost>
 <87ftn3iuqp.fsf@linux.intel.com>
 <20190718164121.GB1533@localhost>
 <87tvalxzzi.fsf@gmail.com>
 <20190813174821.GC3207@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813174821.GC3207@localhost>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 13, 2019 at 10:48:21AM -0700, Richard Cochran wrote:
> > +		if (copy_from_user(&req.extts, (void __user *)arg,
> > +				   sizeof(req.extts))) {
> > +			err = -EFAULT;
> > +			break;
> > +		}
> > +		if (req.extts.flags || req.extts.rsv[0]
> > +				|| req.extts.rsv[1]) {
> > +			err = -EINVAL;
> 
> Since the code is mostly the same as in the PTP_EXTTS_REQUEST case,
> maybe just double up the case statements (like in the other) and add
> an extra test for (cmd == PTP_EXTTS_REQUEST2) for this if-block.

Thinking about the drivers, in the case of the legacy ioctls, let's
also be sure to clear the flags and reserved fields before passing
them to the drivers.

Thanks,
Richard
