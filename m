Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C15EC4D7F41
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 10:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235974AbiCNJ5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 05:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231392AbiCNJ5Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 05:57:16 -0400
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2084D3150E;
        Mon, 14 Mar 2022 02:56:02 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1647251727; bh=4sridcz6NhIta+fxXETtHTpZdUz6k8s5lQo0LNsNvxg=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=SHNBsPHPr313OiPnpxk+GokjEVIY+qm4MPAyAitxiuWEYhAWvhwdd8Nxft4OaRhy0
         LzLzLscgavPoKCjBA/Jq4fbiJit+RTjFTLCmMTmQLbCo8ybhedXtBUdO7vp1DtmZrS
         W2EczPOFEMxBgcTkiibT+Q1BxamfzwEqYUhep81d6oLmTYz1v9ZXvymxf3vVqiY+D1
         ofTqxNKtflt689fIRKclAmVjje5/fjULldiYKi0yWwpLSo44YnsTkEXP1oJPl0pQF+
         WgpQjOIbNc7uchICV+EEdYUhopxKrPgq+kd+wvymTA1aJT4RfP7syyb07wGLCYn2sD
         aAD4nTW9NGyfA==
To:     cgel.zte@gmail.com
Cc:     kvalo@kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH V2] ath9k: Use platform_get_irq() to get the interrupt
In-Reply-To: <20220314064501.2114002-1-chi.minghao@zte.com.cn>
References: <20220314064501.2114002-1-chi.minghao@zte.com.cn>
Date:   Mon, 14 Mar 2022 10:55:27 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87tuc0voxc.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cgel.zte@gmail.com writes:

> From: Minghao Chi <chi.minghao@zte.com.cn>
>
> It is not recommened to use platform_get_resource(pdev, IORESOURCE_IRQ)
> for requesting IRQ's resources any more, as they can be not ready yet in
> case of DT-booting.
>
> platform_get_irq() instead is a recommended way for getting IRQ even if
> it was not retrieved earlier.
>
> It also makes code simpler because we're getting "int" value right away
> and no conversion from resource to int is required.
>
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
