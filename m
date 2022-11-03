Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEB65617697
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 07:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbiKCGIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 02:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbiKCGIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 02:08:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2E5E193C4;
        Wed,  2 Nov 2022 23:08:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E31961D53;
        Thu,  3 Nov 2022 06:08:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4230C433D6;
        Thu,  3 Nov 2022 06:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667455680;
        bh=P1Zq6cY6WSNCfWyU+WHaR/g7Cg93v+I3gcBJVViYx7I=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=MSd1/IYVOvc1P362zJPZ5hBXNs5v+k2toHZjHZLwsC+233Vogc/h8gxvcFSr69tQ8
         0zRyf9JTSRGpLyJ0dxX8dP7NfxuNExk7dihZoK1ZgDzqOEtgj9yO7EaMxPhbOB/6RF
         OL4FcrjeIlI1IPQ1JfAe112CkqyqJoWesieKoAmQDGHs8llkfrr9i1j8ra5oRK6XtS
         WfqVbMN8srwAPR1a1izQlj4l7ARMWQDDpcABAEzwS3+HhN1gI+mbFkLEcWjuKcgElH
         Rc1PKr7GHmW0StFWidl4uMgLg58tO7UcG3iT/qNwR7IsNJrIipH6X4tyhS5Ph7Xl5+
         RzGrMl5Rg0Ppw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] wifi: ath11k: Make QMI message rules const
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220915002303.12206-1-quic_jjohnson@quicinc.com>
References: <20220915002303.12206-1-quic_jjohnson@quicinc.com>
To:     Jeff Johnson <quic_jjohnson@quicinc.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <ath11k@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166745567687.21329.1292963060399122337.kvalo@kernel.org>
Date:   Thu,  3 Nov 2022 06:07:58 +0000 (UTC)
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
> qmi_elem_info") allows QMI message encoding/decoding rules to be
> const, so do that for ath11k.
> 
> Compile tested only.
> 
> Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

93c1592889fc wifi: ath11k: Make QMI message rules const

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220915002303.12206-1-quic_jjohnson@quicinc.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

