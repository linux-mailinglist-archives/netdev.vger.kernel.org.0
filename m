Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C75128BFEA
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 19:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728136AbfHMRtW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 13:49:22 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39750 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726323AbfHMRtW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 13:49:22 -0400
Received: by mail-pf1-f195.google.com with SMTP id f17so48023158pfn.6;
        Tue, 13 Aug 2019 10:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=F66mmM6EpiHfgT+wmNXzuAKlf0zawQ3GnOz6AOmAuGQ=;
        b=bHz038m5C/2FpOEmiV6MVrcdI738f1BL3zH+kWhjdIpc/3B+H7IEhBTqCF66tmHMX1
         C+vwor+2C3z8nK/0emr237nmk2ZncKxMqw32Wm1PjqQQopt1FVnXHfsPwqumOVRXckHB
         6bLJLY+4/vErJ5Lg5Y1yDNxxtTjnZPwBHGFtqjBLm9/Es242+7GT+X/Uc5gHKS91PM4/
         +DlMed5bfIsfef+XwPeg+Sf9HotWs6fd0is9rDklmDKRPa8GslHhHD9nA7Nq3k+6zpVP
         vsidKZR+tIl2Yc3HA4ftwzb9JEdJlZ1aaKoEd1t/3CYWPAk6FVQZgA1nHFUIPCcOY51p
         ILkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=F66mmM6EpiHfgT+wmNXzuAKlf0zawQ3GnOz6AOmAuGQ=;
        b=Fun2T+mJzUqWXOP9GUSiqaXYAYvW+P7D6wW2iPAjvzo0bTY871TxK0NPEcvYzKZtoQ
         iUC1vE2uA34BXpQBU5rW+stcV1wkZtb4lRJkflrq5ojo2irmAROHK74N+DZF2G76HQvj
         3m65f6g/ELS8cyuO3hNieyikp3K/PlrD4t8lYG4IEWkzULgn7iCgDxPgI4bC6WmtJCFM
         yTA6FQkIKnwYlFT+ougVXv4xbA4wlfX3yh/fxql7XcrArQ6ZRWHggtcyL27lNPw/kTaC
         mndGh9MeEy3gfjVlX1efp+b92CRrJhefFzhTVbkai4Ilz258yF7rCWJPLrE9hDHlJkYg
         2h+g==
X-Gm-Message-State: APjAAAXSg1qagzYtZ8zTs5kZyHFb23QT19TXg0RrVn5x/CBSN5ahlX02
        zZY3YltkMpofdsDHpEVH4UE=
X-Google-Smtp-Source: APXvYqxSIN440OuHNUQtrQGpo5lWr5OJoC/yqSvN5iAKUzLDFiFP2TPiu/T5h5+CIOFpui5kECxHZg==
X-Received: by 2002:a17:90a:9ea:: with SMTP id 97mr3217519pjo.68.1565718561499;
        Tue, 13 Aug 2019 10:49:21 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id b3sm128953179pfp.65.2019.08.13.10.49.20
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 13 Aug 2019 10:49:20 -0700 (PDT)
Date:   Tue, 13 Aug 2019 10:49:18 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Felipe Balbi <felipe.balbi@linux.intel.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        "Christopher S . Hall" <christopher.s.hall@intel.com>
Subject: Re: [RFC PATCH 0/5] PTP: add support for Intel's TGPIO controller
Message-ID: <20190813174918.GD3207@localhost>
References: <20190716072038.8408-1-felipe.balbi@linux.intel.com>
 <20190718195040.GL25635@lunn.ch>
 <87h87isci5.fsf@linux.intel.com>
 <20190719132021.GC24930@lunn.ch>
 <87wofhy05t.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wofhy05t.fsf@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 13, 2019 at 10:50:06AM +0300, Felipe Balbi wrote:
> If we do that we make it difficult for those reading specification and
> trying to find the matching driver.

+1

Thanks,
Richard
