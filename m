Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B16051CEB06
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 05:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728606AbgELDCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 23:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728115AbgELDCn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 23:02:43 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D804C061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 20:02:43 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id k7so3804896pjs.5
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 20:02:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=D4jLZHxWsiN1sblA4mg3DvF2dAdqkhSqtvbRTDfkeIQ=;
        b=anrp1iDDvsJunrNq64KJ0AcsKV4VGumPH2gjex7NjcMU5+hEgjmtKzaANl/C3sUZD+
         YTv0KBsKoOlusipjsehJbedmAvz1WjM2g7xpIN4ZgTZ2FxBb7IQzQ3+DRPQ5HxI78Tji
         x+5lWmX4GrYRuDJdIkCxcqsVqASLn6GNGKnPNKjdq7AFsyrqKAXogL57XtJRPfsclmdt
         ieHXS4ManEqqh7AcKmW8GLX1H4+vyVISvtkBTXtnmo/UhUn+ASbGZQ2LLo64OvwBUhT1
         Pc6PwXEsXHfjVQy+WtwPKkFEzgAegylpEGKI0md9dr+iObYJvYzqmPyg2D/wx9IBqSSv
         pGVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=D4jLZHxWsiN1sblA4mg3DvF2dAdqkhSqtvbRTDfkeIQ=;
        b=RNY9qSMiJM+Exh5/S/BK3OtYuYKW5IsAipIkW74sxew94JTCyN9FR2SYS7AOs6iWrB
         DACIlaKigVhBaIfQS1evrySJCv67A4prLrpOV8Fp+Xnr1LRP2pxwGWUMWopSyiwFD/Tz
         InaD5lO24LcVnUWXTSNfW9HFQ/UFgJsoPI4inczC3+IrqR9gQ12lJe/J/ljVKI8w77Hg
         pXqsThJRKb5AkPDCVQA5QFVnu2RByqv5a7+Q/sq/fact4/NMkAWcnJD5iKnbkF73rmT7
         DA5RTIfDCYy8awKWf4OG0k/0mvskaVt/Wo+oz/D7b0Y68J4WJHU6Fjkoa4DQ30D46LPX
         +70Q==
X-Gm-Message-State: AGi0Pub4Q4K+v37zBQBNdYjkMrlhOUWEhc8TRqhZ1/ApcfOqwWjFS9vl
        KnjHY06+FgDbC4CM2RO0ldtXSwDuQXo=
X-Google-Smtp-Source: APiQypJAvcrcWt+jJoqGoE7+F6m4HgZWZU1SatwGmR7FfVhOK3eIVtMr5x8f8vzaQRZgpuyC8D6R6g==
X-Received: by 2002:a17:902:9a81:: with SMTP id w1mr17693834plp.289.1589252562808;
        Mon, 11 May 2020 20:02:42 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id d74sm10622819pfd.70.2020.05.11.20.02.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 20:02:42 -0700 (PDT)
Date:   Mon, 11 May 2020 20:02:40 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] ptp: fix struct member comment for do_aux_work
Message-ID: <20200512030240.GA3613@localhost>
References: <20200511210215.4178242-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200511210215.4178242-1-jacob.e.keller@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 11, 2020 at 02:02:15PM -0700, Jacob Keller wrote:
> The do_aux_work callback had documentation in the structure comment
> which referred to it as "do_work".
> 
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> Cc: Richard Cochran <richardcochran@gmail.com>

Thanks, Jacob, for cleaning this up!

Acked-by: Richard Cochran <richardcochran@gmail.com>
