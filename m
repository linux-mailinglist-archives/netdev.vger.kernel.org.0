Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0530D6BDD65
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 01:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbjCQAKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 20:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjCQAKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 20:10:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34BDA46085;
        Thu, 16 Mar 2023 17:10:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC36F62165;
        Fri, 17 Mar 2023 00:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70D79C433EF;
        Fri, 17 Mar 2023 00:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679011812;
        bh=prvv3k+sMGsqlxyP4+6ieog+u8iiZk3KxdH2QQGTRkw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HqqRB+Qz0eMN0HbAK668cq+QlUFK9ipcMCG41Zcm2CxhXn99JN8v4uhnUOtCFZ5Wj
         lHCjouKAsnNhJ4VV7RSowlGyBB3mr71cz9fv6EvQshT3jbQqY8jZH+bLH0kkwZ9ahF
         1QnRoVQqAgSZsyp29w5YmdrtBvrdDdwbWLk4zveDEl0LbzuzcPJMkzqOnfHTFqsZLz
         5y8SY1eA2I6uXe9DnX/6jWlykDos8gfNKGpYVrrgJ+ZaC7KN3w/PbruKLei3Lfx9xf
         WYIzaY/KLgpHZ0bjgeZHKWO1UrdF+8n+gDVMo9nCxjP/pvV5mW3Vj+qDyvWwHvH+z1
         AiIH6v4WQVK1g==
Date:   Thu, 16 Mar 2023 17:10:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        andersson@kernel.org, konrad.dybcio@linaro.org, agross@kernel.org,
        devicetree@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH v2] dt-bindings: net: qcom,ipa: add SDX65 compatible
Message-ID: <20230316171010.7c51c93c@kernel.org>
In-Reply-To: <20230315194305.1647311-1-elder@linaro.org>
References: <20230315194305.1647311-1-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Mar 2023 14:43:05 -0500 Alex Elder wrote:
> Add support for SDX65, which uses IPA v5.0.
> 
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
> v2: Add review tag; base on linux-next/master; drop "net-next" in subject
> 
> It is my intention to have this patch be taken via the Qualcomm
> repository (not net-next).

That's a bit unusual, no strong feelings but why is that?
Bindings usually go with the code, ipa is a networking thing, right?
