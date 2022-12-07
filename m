Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 994BC645E11
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 16:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbiLGPx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 10:53:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbiLGPxj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 10:53:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 061673B9F8;
        Wed,  7 Dec 2022 07:53:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C97960BC6;
        Wed,  7 Dec 2022 15:53:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB84EC433C1;
        Wed,  7 Dec 2022 15:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670428413;
        bh=7RkxkZPydmgY+dUiToX4cyTrMbv8PtEIFaaPH+OJyTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZUIDnibXsEXYoil1UjplZDSbfOPyvQ/M/UUun9HG+gHEHwIThD7mzfhP22CT6r5/h
         AQmWvJ3hmTVfm1YF6y4X3KirTz5pkTwXyOtC00Nxf/EVe0Iotwev4sMI0PYnMVTBPo
         QalrKnOI7AxjWiHUtZ5nxblvTuAFNx83GzLx6ibFSaqL9vsUjoCZNMJpbRZy2k8kam
         eR0wrngFG16fM0bNDOFMPivuYqk9IYuFkuEcHFqYwmQ31/mg2dDGMNUIm49NvX0kwI
         7AtoMCDigza+HDFjwViZEploqAZdYZwsQZyvhCAixAZFswwHL7/tfCC4XvHBWbKFj4
         2RQdtFhOH67dQ==
From:   Bjorn Andersson <andersson@kernel.org>
To:     srinivas.kandagatla@linaro.org, kuba@kernel.org,
        konrad.dybcio@somainline.org, elder@kernel.org, kvalo@kernel.org,
        edumazet@google.com, quic_jjohnson@quicinc.com,
        mathieu.poirier@linaro.org, davem@davemloft.net, agross@kernel.org,
        pabeni@redhat.com
Cc:     linux-kernel@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        netdev@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v2 0/4] Make QMI message rules const
Date:   Wed,  7 Dec 2022 09:53:26 -0600
Message-Id: <167042840342.3235426.4288324926729574883.b4-ty@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220914234705.28405-1-quic_jjohnson@quicinc.com>
References: <20220912232526.27427-1-quic_jjohnson@quicinc.com> <20220914234705.28405-1-quic_jjohnson@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
      commit: 7bd156cbbd0add4b869a7d997d057b76c329f4e5
[3/4] slimbus: qcom-ngd-ctrl: Make QMI message rules const
      (no commit info)
[4/4] soc: qcom: pdr: Make QMI message rules const
      (no commit info)

Best regards,
-- 
Bjorn Andersson <andersson@kernel.org>
