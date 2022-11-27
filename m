Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEF83639B84
	for <lists+netdev@lfdr.de>; Sun, 27 Nov 2022 16:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbiK0PPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 10:15:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiK0PPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 10:15:05 -0500
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7DD3CDC;
        Sun, 27 Nov 2022 07:15:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=j40ekeFElSRTUtWtf4uTai1Djqh1538q9l9woq5ywmM=; b=XXiBVtjYsFdCIgK47ruEXgWi63
        chbbXYoWn8viKshFPeI4Pp/wV9s+ODdQMcVnkLzkwmYzCyvqKCm7CTbR/9i+f7CwjmHbeAtO0+5mX
        EedFowawd64MuPzeQw4FQloRot6bhlsB397GmjpM7opqKzBGDTd4FC904+Wm0FHu9QNxhG1Zv3nXK
        WUiMkQISKyFinOJariXwDYtDtsj9MA722IPpg4NTfKGtwxqybC5RSjz4Lfp6Ml8/gaOun1lYFmsTe
        bg9UxqDyuP/GikGU8kWY1KDewpdGpte4GUQMzr11IVwrkSnroXyr55tXnWuWLHJ/lrbfxoezQhMLS
        eDarDYcAkiMXyzU+t4xUtUz+u4GFU9pz7q8DBzqnAFjIHTuecpr8RTe139cijMdxwopqbiIBmUyVf
        o4G03qBzxeCeoM27HBK3B9VhlfCGIUgFthVyfHFJfgZegIamIsHWZV1MuS4lXGIxii35nG82Ju+jo
        Zz4SThlvvUpUhRWxh+Mcf+9dUnCHr7x7WISZ/yYs5fTOBYezKFB8rKNQF4lAAYndlI9/mMGd9BtHk
        dT8ik9YnlPS/SFpPvOqqdqElobFqi8lvQX+jRZ41ibzmSCLOqbns1lg/k9Ke+xFZKG1KPyEyaSXoQ
        Yi8+mDsoeEbBxZLuNC2hfvgRKlRPe47hra8Uqo5SY=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [PATCH] 9p: Remove unneeded idr.h #include in the net/9p directory
Date:   Sun, 27 Nov 2022 16:14:44 +0100
Message-ID: <1691295.Xhe5vkXPrl@silver>
In-Reply-To: <9e386018601d7e4a9e5d7da8fc3e9555ebb25c87.1669560387.git.christophe.jaillet@wanadoo.fr>
References: <9e386018601d7e4a9e5d7da8fc3e9555ebb25c87.1669560387.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sunday, November 27, 2022 3:46:45 PM CET Christophe JAILLET wrote:
> The 9p net files don't use IDR or IDA functionalities. So there is no point
> in including <linux/idr.h>.
> Remove it.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---

Reviewed-by: Christian Schoenebeck <linux_oss@crudebyte.com>

>  net/9p/trans_fd.c     | 1 -
>  net/9p/trans_rdma.c   | 1 -
>  net/9p/trans_virtio.c | 1 -
>  3 files changed, 3 deletions(-)



