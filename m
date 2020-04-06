Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BAED19EF2D
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 03:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbgDFBmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Apr 2020 21:42:40 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:60240 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726373AbgDFBmk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Apr 2020 21:42:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=SzZxHbFXKtIbZEOWKwld3suC8XfmTE5GoyAg/oZEh78=; b=BkCAi5AA9gQyPYJOqYejompNAh
        Dtin1jsEJuaxRAPuDlF15hMbs3Aov9XfosH7/E41oo2NzB332PpkCDHb2iT/wyewYmCOwR3nWZY0G
        U0Mr40uP1lBx5jd2/Lq9/3KsMOuiVOGaDuZ5gMUvW2XQ27St96ovNJa80ryuWwK8KBUYBB3u7eLv1
        ZeN1E8/CcRgkG7WH9/7/WwK9vKTjaV41wAst/1mKSMWZ8Wz3DRc5cWDzl1YjrZjwACDMxm3xkpNYz
        0OmM+EbwQSF3LY9ATok1o21+kwepOWQvxg1p+uoG4LiFIF4kyd2Z64+JBJBQ4/qoECcVoAZTv+rp5
        e0h1/3nA==;
Received: from [2601:1c0:6280:3f0::19c2]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jLGmZ-0001oM-4m; Mon, 06 Apr 2020 01:42:35 +0000
Subject: Re: [PATCH v2 net] skbuff.h: Improve the checksum related comments
To:     decui@microsoft.com, willy@infradead.org, netdev@vger.kernel.org,
        davem@davemloft.net, willemb@google.com, kuba@kernel.org,
        simon.horman@netronome.com, sdf@google.com, edumazet@google.com,
        fw@strlen.de, jonathan.lemon@gmail.com, pablo@netfilter.org,
        jeremy@azazel.net, pabeni@redhat.com
Cc:     linux-kernel@vger.kernel.org
References: <1586136369-67251-1-git-send-email-decui@microsoft.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <6efee6bb-d68d-0f83-d469-b173cf4f5d0f@infradead.org>
Date:   Sun, 5 Apr 2020 18:42:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <1586136369-67251-1-git-send-email-decui@microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/5/20 6:26 PM, Dexuan Cui wrote:
> @@ -211,9 +211,9 @@
>   * is implied by the SKB_GSO_* flags in gso_type. Most obviously, if the
>   * gso_type is SKB_GSO_TCPV4 or SKB_GSO_TCPV6, TCP checksum offload as
>   * part of the GSO operation is implied. If a checksum is being offloaded
> - * with GSO then ip_summed is CHECKSUM_PARTIAL, csum_start and csum_offset
> - * are set to refer to the outermost checksum being offload (two offloaded
> - * checksums are possible with UDP encapsulation).
> + * with GSO then ip_summed is CHECKSUM_PARTIAL, and both csum_start and
> + * csum_offset are set to refer to the outermost checksum being offload (two

                                                             being offloaded

> + * offloaded checksums are possible with UDP encapsulation).
>   */
>  
>  /* Don't change this without changing skb_csum_unnecessary! */


Reviewed-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.
-- 
~Randy
