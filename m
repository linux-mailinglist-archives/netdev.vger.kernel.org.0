Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5476BC475
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 04:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbjCPDSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 23:18:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbjCPDSU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 23:18:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 079E321A3E;
        Wed, 15 Mar 2023 20:18:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D257DB81FBE;
        Thu, 16 Mar 2023 03:18:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18ED4C433AA;
        Thu, 16 Mar 2023 03:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678936679;
        bh=2veV2xaJf5ssmKjUauZ5Y3zT1WI8lFivE+RzW+XrW8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IgiEX17qXBlzGAT4MGrFiIiNc79cEJRT3pJMPA6RlSqTKlyam6YYSapyvm/k+Ulqa
         oaRkKDgO5rh1ADhCRN1sPDNOfmzDp6H7q03xgU9UM6z7rF1aIhJdB2grVRXc813c0G
         X+8Q2ZyN0ZebnFvDJJqZUDpVnOgu6oW2M+PVR1xyFpo5t4IFwjHBWW4o6mAuagEMLR
         5wNumIklIdhns3yyGDNFgAAPvE4YOAGv6TxCm/QkQ6BWvDJQdLyAGcvzJ0og4Rq4ib
         ZjIDxNILAa0LKrB9zikjbLJlW+XvEtt26vRyRCPoKEANnV5R87/uarcdfAtBqTgPQj
         HAXAjHnLtsxSw==
From:   Bjorn Andersson <andersson@kernel.org>
To:     Mathieu Poirier <mathieu.poirier@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Kalle Valo <kvalo@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Elliot Berman <quic_eberman@quicinc.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amol Maheshwari <amahesh@qti.qualcomm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        ath10k@lists.infradead.org, linux-remoteproc@vger.kernel.org,
        Gokul krishna Krishnakumar <quic_gokukris@quicinc.com>
Subject: Re: [PATCH] firmware: qcom_scm: Use fixed width src vm bitmap
Date:   Wed, 15 Mar 2023 20:21:01 -0700
Message-Id: <167893686409.303819.14364343251308679131.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230213181832.3489174-1-quic_eberman@quicinc.com>
References: <20230213181832.3489174-1-quic_eberman@quicinc.com>
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

On Mon, 13 Feb 2023 10:18:29 -0800, Elliot Berman wrote:
> The maximum VMID for assign_mem is 63. Use a u64 to represent this
> bitmap instead of architecture-dependent "unsigned int" which varies in
> size on 32-bit and 64-bit platforms.
> 
> 

Applied, thanks!

[1/1] firmware: qcom_scm: Use fixed width src vm bitmap
      commit: 968a26a07f75377afbd4f7bb18ef587a1443c244

Best regards,
-- 
Bjorn Andersson <andersson@kernel.org>
