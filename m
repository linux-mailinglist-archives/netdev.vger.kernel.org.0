Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84C05625FCA
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 17:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234285AbiKKQrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 11:47:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233938AbiKKQrS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 11:47:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9568D836BF;
        Fri, 11 Nov 2022 08:47:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4FE6DB82670;
        Fri, 11 Nov 2022 16:47:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78AA9C433C1;
        Fri, 11 Nov 2022 16:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668185234;
        bh=LwhJGLEfSkfTskA9KybUESIxesCQ0DPf6xYj+bgbvLs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sCpzFBXvuCOJQtE+LbnmnPTc9hKbE3kuYZ5dZIlfFUBPaQicQcqUTKvIaWnKuH5Bo
         C7nK7R/hnCC91eYsQ2+sfa8c3iuhFCSF7ruHaUHyBpe9kV85ZUlLnNYYklmWoKpGv3
         Fzkm23SUx02FfJqiIbNs8IQM5i+Y17YzZTKndnePlU6OvVhWjeHOPrtQT4DBnXRaBh
         i/rwcdnt2hVYjBCJT6sVlsa50ulK2gT3Ta1p90yRtgNllIaNuqugSg/CwM0sGf0Po2
         ZeDo2IX5wOPS0KaZSlEk8XUVh+FAH3kVCKg9uDHYexpdDTzqA9QTKv3zAr77wZqWm1
         AphFvmJYHkWkQ==
Date:   Fri, 11 Nov 2022 10:46:56 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     Sudarsana Kalluru <skalluru@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com, Rasesh Mody <rmody@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH v3 6/7] bna: Avoid clashing function prototypes
Message-ID: <Y258gPo/WE6AbV+o@work>
References: <cover.1667934775.git.gustavoars@kernel.org>
 <f813f239cd75c341e26909f59f153cb9b72b1267.1667934775.git.gustavoars@kernel.org>
 <87v8nns6t4.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87v8nns6t4.fsf@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Mixing wifi and ethernet patches in the same patch is not a good idea,
> the network maintainers might miss this patch. I recommend submitting
> patch 6 separately.

OK.

In the meantime, can you take patches 1-5? :)

Thanks!
--
Gustavo
