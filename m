Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8216602264
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 05:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231435AbiJRDSs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 23:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231443AbiJRDSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 23:18:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02C529C7DB;
        Mon, 17 Oct 2022 20:16:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3446961422;
        Tue, 18 Oct 2022 03:14:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76590C43141;
        Tue, 18 Oct 2022 03:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666062878;
        bh=KUiKr47b0U7BG8MHMA6x9yTYT7DWpF6dS63ARtGfCF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H7jsiAFbzP4JuXJyZqurlXGzTQ0FqvwY2WdeRdacspPbGEcg8kV4gn19U9akH08lR
         Ej8kikb0MoYThUOzVaIEW2TQmLqqpXb8NzW64G1ggOlQ8NLC2JEtxM6osfiG8PlWRD
         An27KT5zll6ZfSjupHvU0Z/qvUQ5QFOU6OlcFk/0Av6PGAm8SxkGLWOJkvMzOd7H0W
         tM+invoJZw7rB6sPimsL8GibmCb/SC96gz+BiTowqEZjBLKAFbOndKlbeOdJNB4D2T
         qS42Ld/ax78q7V/OkiT3HuGrQl87Rk5F6uhCTyPebOsAQ9j4fWE76mL1+cGkFeP3uf
         1Y0NduoqX4XWQ==
From:   Bjorn Andersson <andersson@kernel.org>
To:     pabeni@redhat.com, kuba@kernel.org, kvalo@kernel.org,
        mathieu.poirier@linaro.org, elder@kernel.org,
        quic_jjohnson@quicinc.com, edumazet@google.com,
        srinivas.kandagatla@linaro.org, davem@davemloft.net,
        agross@kernel.org, Konrad Dybcio <konrad.dybcio@somainline.org>
Cc:     alsa-devel@alsa-project.org, linux-remoteproc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 0/4] Make QMI message rules const
Date:   Mon, 17 Oct 2022 22:14:29 -0500
Message-Id: <166606235855.3553294.15415652032581758108.b4-ty@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220914234705.28405-1-quic_jjohnson@quicinc.com>
References: <20220912232526.27427-1-quic_jjohnson@quicinc.com> <20220914234705.28405-1-quic_jjohnson@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 14 Sep 2022 16:47:01 -0700, Jeff Johnson wrote:
> Commit ff6d365898d4 ("soc: qcom: qmi: use const for struct
> qmi_elem_info") allows QMI message encoding/decoding rules to be
> const. So now update the definitions in the various clients to take
> advantage of this. Patches for ath10k and ath11k were previously sent
> separately.
> 
> This series depends upon:
> https://git.kernel.org/pub/scm/linux/kernel/git/qcom/linux.git/commit/?h=for-next&id=ff6d365898d4d31bd557954c7fc53f38977b491c
> 
> [...]

Applied, thanks!

[1/4] net: ipa: Make QMI message rules const
      (no commit info)
[2/4] remoteproc: sysmon: Make QMI message rules const
      (no commit info)
[3/4] slimbus: qcom-ngd-ctrl: Make QMI message rules const
      (no commit info)
[4/4] soc: qcom: pdr: Make QMI message rules const
      commit: afc7b849ebcf063ca84a79c749d4996a8781fc55

Best regards,
-- 
Bjorn Andersson <andersson@kernel.org>
