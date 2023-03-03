Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF826A97AA
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 13:56:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbjCCM4x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 07:56:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbjCCM4v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 07:56:51 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 311164ECDB;
        Fri,  3 Mar 2023 04:56:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9478CCE2127;
        Fri,  3 Mar 2023 12:56:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C0A9C433D2;
        Fri,  3 Mar 2023 12:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677848206;
        bh=+b8VhHcKMAf5AlRnGJugTeQ8FLmcJRwHbHLB2Me/d0Q=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=K5f/zp+h6k4W5qp3yW46hJu0292vk2WgBvLP0LSDar561Y18RqRCAqtIamAqCNlIh
         6vzY2NhmQ7bb2QSXtIQ1CoM+iT7BNp4ei+wE4uebPF3RHAY/gzlkkFQlHPW9yJg5lB
         Vst1998vixy+qVvhpEWwdaSaPG0XlPG2R2p4J3DSSigFwybKqQZMDjKq/6UIvfq7sO
         5faVefergO6ULYEzBmILazHWwBIX8bDHHhv7WrMYUWynKgG+4Sa3O1PLQFNpLY1b8z
         jp+2+S+tV/ps5L+VldD5MnDq4nCofjPZQJLOXg4B2EY+m0RyuwWe06FSjBFfhjRpU5
         qnVjCNvoaW5GQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Konrad Dybcio <konrad.dybcio@linaro.org>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        linux-arm-msm@vger.kernel.org, andersson@kernel.org,
        agross@kernel.org, marijn.suijten@somainline.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] dt-bindings: ath10k: Add vdd-smps supply
References: <20230303024246.2175382-1-konrad.dybcio@linaro.org>
        <8e695c64-6abd-3c1e-8d80-de636d950442@linaro.org>
        <41665c73-1647-2cb2-bd33-8dc281a97ee5@linaro.org>
Date:   Fri, 03 Mar 2023 14:56:36 +0200
In-Reply-To: <41665c73-1647-2cb2-bd33-8dc281a97ee5@linaro.org> (Konrad
        Dybcio's message of "Fri, 3 Mar 2023 12:28:21 +0100")
Message-ID: <87o7payovv.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Konrad Dybcio <konrad.dybcio@linaro.org> writes:

> On 3.03.2023 08:12, Krzysztof Kozlowski wrote:
>> On 03/03/2023 03:42, Konrad Dybcio wrote:
>>> Mention the newly added vdd-smps supply.
>> 
>> There is no explanation here, but looking at your driver change it
>> suggests name is not correct. You named it based on regulator (so the
>> provider), not the consumer.

Yeah, it would be nice to have more than just one sentence in the commit
log.

> Right, I admit this could have been posted with an RFC tag.
> Maybe Kalle knows more.

Unfortunately not, but maybe Bjorn knows?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
