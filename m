Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54796617695
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 07:07:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbiKCGHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 02:07:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231246AbiKCGHF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 02:07:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B575B193C4;
        Wed,  2 Nov 2022 23:07:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67689B82623;
        Thu,  3 Nov 2022 06:07:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33235C433D6;
        Thu,  3 Nov 2022 06:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667455621;
        bh=LPrafYX9hEsEzaF5fMXuFCwDsoy3H56OcRw/rH9JSXM=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=SFHvRsWL6B4CnT0K6atnhiGEFmoh72vRzlJkk0ycPcCDJUWg8XaCq0gyic1c37aST
         53sfpIR/srKbe851c5z2J/rGT0AttdFSo2eSLVFQjaB+kEdab9BN/SqDBdjjmi5WXG
         eH/Ysi5IJbAJssr1GQoxFSPmIECgKvCKQzhqEnswoWaclVGpAdh7fsmwBThpdJ1t1x
         pkVCeiEqlBsCZ5PcJmKzHcdTe5RSpCk4jcYPhCTS9P+cq/Bt3oyb526N8pZD4lduqU
         axBDLByaWX2JZgK2XvDdrxaFNDWfN7D5vl9sDU59c0nZWeRY0/Dpfml5GGhceFNrGj
         XaDjDuOuT+LCA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] wifi: ath10k: Make QMI message rules const
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220915002612.13394-1-quic_jjohnson@quicinc.com>
References: <20220915002612.13394-1-quic_jjohnson@quicinc.com>
To:     Jeff Johnson <quic_jjohnson@quicinc.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <ath10k@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166745561698.21329.18124838626287583830.kvalo@kernel.org>
Date:   Thu,  3 Nov 2022 06:06:59 +0000 (UTC)
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jeff Johnson <quic_jjohnson@quicinc.com> wrote:

> Commit ff6d365898d4 ("soc: qcom: qmi: use const for struct
> qmi_elem_info") allows QMI message encoding/decoding rules
> to be const, so do that for ath10k.
> 
> Compile tested only.
> 
> Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

11e1fcf2b494 wifi: ath10k: Make QMI message rules const

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220915002612.13394-1-quic_jjohnson@quicinc.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

