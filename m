Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B61F04892DC
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 08:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240765AbiAJH4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 02:56:13 -0500
Received: from out203-205-221-231.mail.qq.com ([203.205.221.231]:45143 "EHLO
        out203-205-221-231.mail.qq.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243617AbiAJHzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 02:55:35 -0500
X-Greylist: delayed 81453 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Jan 2022 02:55:34 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1641801331;
        bh=4/D9bsQYTExfGj/Kw0XJPUykeRczvoxzNQdeTQGgfuU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=W0tUDhWzYPJO3i4EA6pAXYA1kSzFrGWAW0hJJO+TUXriOJR42DZFeojvdXoEz5Qd1
         ES7fRMxVaXxaTroOkJtzVCLnkhBZ+EBjXQ8S/aEPCtzXRM0wBLtCdr8/IsN/DQKj5z
         y/0X1/Kkr9QBIFt2ZQ6PdcB4qDGSw5Tyoh1k/OVI=
Received: from localhost ([119.32.47.91])
        by newxmesmtplogicsvrszc11.qq.com (NewEsmtp) with SMTP
        id BC28D21C; Mon, 10 Jan 2022 15:47:02 +0800
X-QQ-mid: xmsmtpt1641800822tp8masu2j
Message-ID: <tencent_15A7824636308FBA779482A8D296ADB0A607@qq.com>
X-QQ-XMAILINFO: OfSYiviZO9YdmdcN850B6VCN5Oun1MpScidBKLKEp7n/KUBzvVWUy7r/3bu2W7
         +6drgSgykPAuOjYqgg5zL+lFC9XKXiYNILxmjF6UYaFDITEVjM4RFT5CbZme/Ntb2O1+e/nLh5bS
         OltW0hy1Q7GeBLvee725G75N6/AqIlWNXcP6H/WRcTpZRvcVukwJhBN+f96s/OvR2sAyOXPm5L3b
         mXLpdbmUgIHNSMDluBc0RN4cSUrzj/YDlPW+GXBPChp5QUawTbA463xv/ltFXEKfWbpp8YAbihz9
         YJnaAnwWmxPQFVCGvv1Ns8tcOEQIZIrX60OOg8g8w9xLTPg0nEXC6+im/vE1cYcZbU0/UdrYNK29
         drzBGlNd+UwAsgaFOI34xhYNypwov/Kaw9Ri9OGkuERcIUypQV2mWmoX20mbmkuE7KVZgkoAkPP0
         ku3I4v41RHbq44WEe8Fq+zdzi5sPaebxlayMqWk5JzfbUSChamgWc4IrOxqNiACWf1+FizIIu1nJ
         48PxKoWzxjs4DjSsaNxo2gophzwmdhjy4G1Q9C4snwN8mNPqp/kBCd2/E8d0PDYAiX3qbqStwEDg
         3cnPfZsYVWB2vZ/EK1QDOHrHQPyGqk5PatjgnZHxOw/0qgLq0FilBDCrL7hOKUTz0ZtFsffw/Gg7
         m07cABaDstdZAz6wgieiGzrn9a2T2dePd9WiP2TxKW1P2sA/6MyWOJHp3N5u69okDU3RuX1GNmSQ
         6EmoQHbU1H8CoykI4rraXuAE8Zbh9guwoQdYLDxqc1pRaGNpldgBfyT/U9bb9P+9HDfaR0yvMes8
         lyiw4B98NOAm9NUDOhkVmuAnE1Mi8nGr3ONlNhi/3bSN6/pckAnihbmXueKCsD9N5PrCIyLH3baO
         zzjXf6ATYN
Date:   Mon, 10 Jan 2022 15:47:02 +0800
From:   Conley Lee <conleylee@foxmail.com>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     davem@davemloft.net, mripard@kernel.org, wens@csie.org,
        jernej.skrabec@gmail.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] sun4i-emac.c: enable emac tx dma
X-OQ-MSGID: <Ydvkdjh+uL0wALF5@fedora>
References: <YdLhQjUTobcLq73j@Red>
 <tencent_E4BA4D6105A46CCC1E8AEF48057EA5FE5B08@qq.com>
 <YdtJTQJJ4aEUcp/D@Red>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YdtJTQJJ4aEUcp/D@Red>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/09/22 at 09:45下午, Corentin Labbe wrote:
> Date: Sun, 9 Jan 2022 21:45:01 +0100
> From: Corentin Labbe <clabbe.montjoie@gmail.com>
> To: conleylee@foxmail.com
> Cc: davem@davemloft.net, mripard@kernel.org, wens@csie.org,
>  jernej.skrabec@gmail.com, netdev@vger.kernel.org,
>  linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
>  linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v1] sun4i-emac.c: enable emac tx dma
> 
> Le Sun, Jan 09, 2022 at 05:17:55PM +0800, conleylee@foxmail.com a écrit :
> > From: conley <conleylee@foxmail.com>
> > 
> > Hello
> > I am reading the R40 user manual and trying to create a new path to enable
> > emac tx dma channel. According to the figure 8-21(TX Operation Diagram),
> > I try to enable emac tx dma channel by the follow steps:
> > 1. enable tx dma mode
> > 2. set packet lengths
> > 2. move data from skb to tx fifo by using dma in xmit function.
> > 3. start transfer from tx fifo to phy in dma tx done callback
> > 
> > But it doesn't work. emac tx interrupt and dma finished interrupt are
> > raised, but no packets are transmitted (I test it by tcpdump).
> > Do you know how to configure the emac tx dma correctly? Thanks ~
> > 
> 
> Hello
> 
> Here are my thoughts to help you:
> - Your email is not a real patch, but an ask for help, so you should not use [ PATCH ] in the subject.
> - If it was a patch, "v1" is not necessary
> - Your patch below is doing too many unrelated different things, it is hard to see the DMA TX enable part
> - I think you could first send a preliminary patch which adds all EMAC_INT_CTL_TX_xxx which are already used by the driver (to reduce the diff)
> - Without the DTB change, it is hard to see the whole picture, did you correctly use the right dma number for an easy example.
> - Knowing also the board (and so PHY, modes etc...) could help
> - I think your priority should not to add TX, but to fix reported problems to your initial patch (build warnings/error https://marc.info/?l=linux-arm-kernel&m=164159846213585&w=2) since your work on TX will need to be applied after this.
> - For the previous point, always build test with at least 2 different 32/64 arch. And if possible a total different arch (like x86_64).
> 
> Anyway, I will try to test your patch on my a10 board
> 
> Regards
Thanks a lot for your help ~ I will submit an patch which add all
register related. By the way, the build warnings problems have been fixed
by Jakub Kicinski <kuba@kernel.org>.
