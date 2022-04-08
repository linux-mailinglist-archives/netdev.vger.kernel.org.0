Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D42504F9498
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 13:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235208AbiDHLzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 07:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232152AbiDHLzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 07:55:45 -0400
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A15F7DE0B;
        Fri,  8 Apr 2022 04:53:39 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1649418816; bh=zivYut1AiMU4O2qsRQrApqir8I1ZCtnVZttACI98ZsU=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=JHPHxpd7Y6BHAvmVpiYcZHXKmphnE0W2EJDlgJg1iujP7WCLJj5uzJGMuVd4a4Pmv
         aRPf75G5493uN3+C/eYwK0j1SHL0+jaITiixsMxrulPhn/vcP2sKMYZo0dv3MaXCix
         RoGabv5HCLnY/b3LjwEvO41wSx5uymKIrupuOOkdNaUF9BR9icljuhXqVyidFXPcvu
         AiHY90NxRJSuVj3OKnHEGgUJ9s9dBBog/it08ChgV0l6sczoJGQ/0GcwBgjLa144Lg
         x2Bqt0gYsjdijYYDpLSe4Kpfo+PCW6WA4WWMWbUP+YEuF9YtrY5oG42PW/coD8F8et
         0A/dgrYVYVCqA==
To:     Yang Li <yang.lee@linux.alibaba.com>, kvalo@kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        loic.poulain@linaro.org, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH -next 2/2] ath9k: Remove unnecessary print function
 dev_err()
In-Reply-To: <20220408000113.129906-2-yang.lee@linux.alibaba.com>
References: <20220408000113.129906-1-yang.lee@linux.alibaba.com>
 <20220408000113.129906-2-yang.lee@linux.alibaba.com>
Date:   Fri, 08 Apr 2022 13:53:35 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87h77394g0.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yang Li <yang.lee@linux.alibaba.com> writes:

> The print function dev_err() is redundant because
> platform_get_irq_byname() already prints an error.
>
> Eliminate the follow coccicheck warning:
> ./drivers/net/wireless/ath/ath9k/ahb.c:103:2-9: line 103 is redundant
> because platform_get_irq() already prints an error
>
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>

Heh, so I was the one originally insisting on keeping that err print,
but looking a bit closer now it does really appear to be redundant, so:

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
