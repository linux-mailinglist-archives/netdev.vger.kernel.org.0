Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1991FEB75
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 08:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727809AbgFRG3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 02:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725898AbgFRG3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 02:29:53 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53B5FC06174E;
        Wed, 17 Jun 2020 23:29:53 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id n2so2007880pld.13;
        Wed, 17 Jun 2020 23:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=KQ2KXadNszv6SfxDIzV7J9NVKQv2wwsb+/cXUurR5GM=;
        b=DYrOt0uKM0IHriWam8HTNRN9UuM6nX+aOJ8xmUqqK/Op1aQNYNm2ZeJ3VvPooSUriO
         C/GJJiDHNTciGVGXltJwSMuV7sGFD7zKdMshcUDaCL5Jxx1B1XKAzz7wFUqB3eyWkoIA
         GArMFuV0upHXRjKwDFMMaBPOgjWGZJjuuHAaSpeTBaozQcKBdpHnFedPqmmvBSxRq3ZW
         7GKwcrBWCkDdMbQ8xqFFkCJRodgU+LzjDJX3LycC2jgp9TYrFgNtPkhh07JGQ0gnt5Vv
         65/psM96IaS9ZIFmD47TUTvtJwR3vSuvfjWW2Ig6lDlKQE2tC9+nmMpggtiIFC9noOBt
         /0mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=KQ2KXadNszv6SfxDIzV7J9NVKQv2wwsb+/cXUurR5GM=;
        b=jBny377DkbgrJVJ9Y7t58uOZCZYqPvygDtj37G3Ej5GOhqp5nXxUtY6E55uXpXthkV
         JsVgAlVxcQKJlrkH9E5OQw+8vwxpaH8EmEIxogpWUJiOKXM2YV/bOkf0Z1TzALRLxT+L
         erk9PShgatKiqtTukNxCE5AiSD1U6/MktFNFz/2ZRJBh02gaGfvvojx8xxg4g3OF36nY
         N1XnC6UyDd0/zrf59VxriUznnfL6/Cs2cOXaCAfqo5bsCzRYMToghg0x01ur5J7kYGmS
         bVYBRNW2PDfyjmMSleqN5yi8ZThkeIZODLFLfpgHllz+vC9Pxg2ZS4C78J0jPx4SWcO+
         K8vg==
X-Gm-Message-State: AOAM531GcjgNf2TlwoTHZxjmDnutM6Dclt2S4HiuW7ovrwhenhRUq3aE
        Wq1Fc1Z0hP4Hx4xgTlI0R5Q=
X-Google-Smtp-Source: ABdhPJzhNgB6nIJWV0vcJORiKu8vr3ckXLQInfPzfhQgk1wdu0Eh6YueIIVSZd/ictQ9XnPqUdWCLA==
X-Received: by 2002:a17:90a:c7d0:: with SMTP id gf16mr2601883pjb.151.1592461792912;
        Wed, 17 Jun 2020 23:29:52 -0700 (PDT)
Received: from localhost ([43.224.245.180])
        by smtp.gmail.com with ESMTPSA id oc6sm1426356pjb.43.2020.06.17.23.29.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Jun 2020 23:29:51 -0700 (PDT)
Date:   Thu, 18 Jun 2020 14:27:37 +0800
From:   Geliang Tang <geliangtang@gmail.com>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] add MP_PRIO, MP_FAIL and MP_FASTCLOSE
 suboptions handling
Message-ID: <20200618062737.GA21303@OptiPlex>
References: <cover.1592289629.git.geliangtang@gmail.com>
 <04ae76d9-231a-de8e-ad33-1e4e80bb314c@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04ae76d9-231a-de8e-ad33-1e4e80bb314c@tessares.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 16, 2020 at 05:18:56PM +0200, Matthieu Baerts wrote:
> Hi Geliang
> 
> On 16/06/2020 08:47, Geliang Tang wrote:
> > Add handling for sending and receiving the MP_PRIO, MP_FAIL, and
> > MP_FASTCLOSE suboptions.
> 
> Thank you for the patches!
> 
> Unfortunately, I don't think it would be wise to accept them now: for the
> moment, these suboptions are ignored at the reception. If we accept them and
> change some variables like you did, we would need to make sure the kernel is
> still acting correctly. In other words, we would need tests:
> * For MP_PRIO, there are still quite some works to do regarding the
> scheduling of the packets between the different MPTCP subflows to do before
> supporting this.
> * For MP_FAIL, we should forward the info to the path manager.
> * For MP_FASTCLOSE, we should close connections and ACK this.
> 
> Also, net-next is closed for the moment:
> http://vger.kernel.org/~davem/net-next.html
> 
> I would suggest you to discuss about that on MPTCP mailing list. We also
> have meetings every Thursday. New devs are always welcome to contribute to
> new features and bug-fixes!
> 

Hi Matt,

Thanks for your reply. I will do these tests and improve my patches.

-Geliang

> Cheers,
> Matt
> -- 
> Tessares | Belgium | Hybrid Access Solutions
> www.tessares.net
