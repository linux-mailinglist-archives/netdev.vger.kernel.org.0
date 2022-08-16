Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAE8F5960A6
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 18:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236655AbiHPQ4E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 12:56:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230416AbiHPQ4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 12:56:02 -0400
X-Greylist: delayed 599 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 16 Aug 2022 09:56:01 PDT
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D90F7C52E;
        Tue, 16 Aug 2022 09:56:01 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1660668017; bh=YXaNHGMYKcjnJgddXdsTHTKJZxjmymYUBGBhAxB3I4o=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=DXfoS0miGmxKBA8B2KiiSBadXfu6qRGg+xljltxxTrQPrbTHAakuf4QR+TQvkn7vB
         Y2GLQQHjCapNS7IUT9wfOkb0I/4RHmnuFIKaETruLe+ryJNv5WrDcHS47PZtIoaXq4
         DOdDbdrukydiRLSsiBPGOzKxPIEWhzedQsLvG/uUFzgZhj5Y+EuUs9Pc9FIQQVTvPS
         hrag/niyLG3+nXfzk7mHGo01m+3qpgYSp0oA/uIMbRnVAaW/a+tDwnM3rU1rKhypNM
         JMnhCGlo2xPbAE91QARGMYQv1iRbkswK/Ympepn+JGj8x+F9exI9nsGEnTprtKn3Zr
         oETRD+T/vUMwg==
To:     Jilin Yuan <yuanjilin@cdjrlc.com>, kvalo@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: Re: [PATCH] wifi: ath9k: fix repeated words in comments
In-Reply-To: <87y1vouoqs.fsf@toke.dk>
References: <20220709123724.46525-1-yuanjilin@cdjrlc.com>
 <87y1vouoqs.fsf@toke.dk>
Date:   Tue, 16 Aug 2022 18:40:17 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87v8qsuopa.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk> writes:

> Jilin Yuan <yuanjilin@cdjrlc.com> writes:
>
>>  Delete the redundant word 'the'.
>>  Delete the redundant word 'to'.
>>
>> Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
>
> Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>

However, the patch does not apply cleanly to the ath-next tree. Please
fix that and resubmit, retaining my ACK...

-Toke
