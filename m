Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1F2434AD9
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 14:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbhJTMMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 08:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbhJTMMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 08:12:24 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44CDFC06161C
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 05:10:10 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id q19so2798397pfl.4
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 05:10:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ftphP/rRhj3HAi/sY+WrPVk0b2hRaTcyx6DeAasFrXQ=;
        b=B0CIzVA8hGKlxBlbLI2TXw1a7ZZ4cI4SHyOME6mYX/zv8h4K7atw3/cZ4aDOymv95H
         3X5Vg7NcqP2XVepAF19Wi7bXeCwcTyJNS4yhadeU5Yel9wMMCqgaqG/kbZboDs3juflh
         OE4H7vqblU4SZteOWMPRSoradW0IED43Y4hJoBd/vB0TF3QdJelCYOyl4TRKsJ2w0Fil
         H/LEvKfwxRdcV3teg2VNyy6KOYPaPnZ7GwhPlAPYg/UYt7Rc8/5J5YEB0C///25Qz+23
         YAtZl6d8tjINLeAZV+twu5jaS3jbnj992LyKB5XZKTG0FSmplO5f+K9RWcH8Gt9V7S0M
         BhIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ftphP/rRhj3HAi/sY+WrPVk0b2hRaTcyx6DeAasFrXQ=;
        b=YLuYya5IXIFyLmeFV0AJmq8/AdzAArshnSjidmy2W4h7v2GmtsyBdSOykMckPI9MJT
         uwY4w5eQNC343TMgFpFLARJrofDZY37i8YE4EOf6oNYGyEdYvd3WNtraDrr+PplwxJp1
         6ezd4fI/ZQIbZ7hrBTW8H6BashYgTYjdcFH+SKA45313IPgga519CBv23ZTKNsqD53JS
         OHHBRuOeAtLWt+10DEngyKjQgQEzZOXu5guD8n4GpTBdT7sij3YRaThgt3VAqhqIsl7U
         eWAO4Ny65o+U/hy5TxAvmTu8V1iQ8cFVnnr2PPIBvUz+85iOIlZziwc+lMeIiulNVTFt
         rJGw==
X-Gm-Message-State: AOAM532ofhPonAAEMUPQN9he+KCSMwlKwla1TkiYztoHKsV5YuLcrsfl
        us4gK75cth/93P55w60uDlk=
X-Google-Smtp-Source: ABdhPJwDqkv/QWkMwSTv7clGOxVT91szFLgmv2smVxJYwGLdcgsCHe+9J6TNTh3Id5LSLIBBZl7wNQ==
X-Received: by 2002:a05:6a00:815:b0:44d:2193:f688 with SMTP id m21-20020a056a00081500b0044d2193f688mr5972528pfk.4.1634731809690;
        Wed, 20 Oct 2021 05:10:09 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id rm14sm5842795pjb.4.2021.10.20.05.10.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 05:10:09 -0700 (PDT)
Date:   Wed, 20 Oct 2021 20:10:04 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     netdev@vger.kernel.org, Nikolay Aleksandrov <razor@blackwall.org>,
        roopa@nvidia.com, bridge@lists.linux-foundation.org,
        davem@davemloft.net, kuba@kernel.org
Subject: Re: [PATCHv2 net] net: bridge: mcast: QRI must be less than QI
Message-ID: <YXAHHBYtFfXbd1hE@Laptop-X1>
References: <20211020023604.695416-1-liuhangbin@gmail.com>
 <20211020024016.695678-1-liuhangbin@gmail.com>
 <c041a184-92cb-0ebd-25e9-13bfc6413fc9@nvidia.com>
 <YW/tLekS17ZF9/w1@Laptop-X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YW/tLekS17ZF9/w1@Laptop-X1>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 20, 2021 at 06:19:25PM +0800, Hangbin Liu wrote:
> On Wed, Oct 20, 2021 at 12:49:17PM +0300, Nikolay Aleksandrov wrote:
> > Nacked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
> > 
> > I think we just discussed this a day ago? It is the same problem -
> > while we all agree the values should follow the RFC, users have had
> > the option to set any values forever (even non-RFC compliant ones).
> > This change risks breaking user-space.
> 
> OK, I misunderstood your reply in last mail. I thought you only object to
> disabling no meaning values(e.g. set timer to 0, which not is forbid by the
> RFC). I don't know you also reject to follow a *MUST* rule defined in the RFC.

I know you denied the patch due to user-space compatibility. Forgive me
if my last reply sound a little aggressive.

Thanks
Hangbin
