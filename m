Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD483436E8
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 03:57:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbhCVC5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 22:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbhCVC4r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 22:56:47 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6B16C061574;
        Sun, 21 Mar 2021 19:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=e0BNuDjzdIaSTsVYrS6v9Yb6zAxMkQCvlSdpRpd8Qxw=; b=f5JCBASiK3eS8KxXn8iioSF+ly
        H/5Im6+aoT6bCe9SEybTf7QO9PvPzafw/8DH8Pjfr7FoNuhGLhr0cmXVVXBbnE8aikRQY/8jv66Ro
        nDeiQGPrH4awxSN0OqxF4cLQecJrskCxHco0DlzQSzVb35ZCekYf8Lxw31MUppBOaGuRTvtah8KzX
        fJ0eCTwA1EjE92oE5IdDoPTXkbPk/pJ5YUecO6gSSrVLmOQbgLJw2IWq1O4JpgoSWr9M5poF+mImU
        3YWl21lJO/kYd/LfOiZNmJw9j8HhRpazrm2m2qfmAoksBVkIdV9/Ve4QsdofcP89IcI1Zh4oKt1JX
        Xw/v+ahw==;
Received: from [2601:1c0:6280:3f0::3ba4]
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lOAk9-00AjZA-CH; Mon, 22 Mar 2021 02:56:37 +0000
Subject: Re: [PATCH] openvswitch: Fix a typo
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, pshelar@ovn.org,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        dev@openvswitch.org, linux-kernel@vger.kernel.org
References: <20210322021708.3687398-1-unixbhaskar@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <4e9a7860-39c5-ed53-32d8-d88408dbfcae@infradead.org>
Date:   Sun, 21 Mar 2021 19:56:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210322021708.3687398-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/21/21 7:17 PM, Bhaskar Chowdhury wrote:
> 
> s/subsytem/subsystem/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

> ---
>  net/openvswitch/vport.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/openvswitch/vport.h b/net/openvswitch/vport.h
> index 1eb7495ac5b4..8a930ca6d6b1 100644
> --- a/net/openvswitch/vport.h
> +++ b/net/openvswitch/vport.h
> @@ -20,7 +20,7 @@
>  struct vport;
>  struct vport_parms;
> 
> -/* The following definitions are for users of the vport subsytem: */
> +/* The following definitions are for users of the vport subsystem: */
> 
>  int ovs_vport_init(void);
>  void ovs_vport_exit(void);
> --


-- 
~Randy

