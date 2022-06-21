Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E683552FFE
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 12:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233059AbiFUKpc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 06:45:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231461AbiFUKp0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 06:45:26 -0400
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 753A7286D4;
        Tue, 21 Jun 2022 03:45:20 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1655808316; bh=vx8h6+L8D85x6Ka256LnDLW4qNsUpfvpPspaIzHFpGk=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=e+qfih2jGoL2toeWj/c92mCBpTjOlkg3YVUTP6GSpnNASHlOpycpatqoOVZPW4mD8
         NZc7vynp0Pt9ssULEYXujCX4WwsCLS8sYUFc4nPfF2n5OL+PVG63GEj7eJFdnP4yZB
         388lsVUV9AuBM1c6BXtJBWkJDHD4QfwOtur88AtEPLW9ZElggyBZ1TpRMzUHJEcLpb
         t/x3dOz+13mjgkF4CjGlOzTeVEjUNjgkC+zelTnfcMEBS1A18d3PhhAZVuX4ImcVRy
         3PGWQQESUsNwFUir4JUH5lNl4d0KZ2CuWU7ERvX0JySx7o+ea3pftne6/j1RGLSjl6
         XF/cLo6lP+SUw==
To:     Jiang Jian <jiangjian@cdjrlc.com>
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jiangjian@cdjrlc.com
Subject: Re: [PATCH] ath9k: remove unexpected words "the" in comments
In-Reply-To: <20220621080240.42198-1-jiangjian@cdjrlc.com>
References: <20220621080240.42198-1-jiangjian@cdjrlc.com>
Date:   Tue, 21 Jun 2022 12:45:16 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87pmj2b8hv.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiang Jian <jiangjian@cdjrlc.com> writes:

> there is unexpected word "the" in comments need to remove
>
> Signed-off-by: Jiang Jian <jiangjian@cdjrlc.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
