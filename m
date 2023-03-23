Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 646446C6054
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 08:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbjCWHBz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 03:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbjCWHBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 03:01:36 -0400
Received: from muru.com (muru.com [72.249.23.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 414EC22117;
        Thu, 23 Mar 2023 00:01:10 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id D12FC80CF;
        Thu, 23 Mar 2023 07:00:33 +0000 (UTC)
Date:   Thu, 23 Mar 2023 09:00:32 +0200
From:   Tony Lindgren <tony@atomide.com>
To:     MD Danish Anwar <danishanwar@ti.com>
Cc:     "Andrew F. Davis" <afd@ti.com>, Suman Anna <s-anna@ti.com>,
        Roger Quadros <rogerq@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Nishanth Menon <nm@ti.com>, linux-remoteproc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, srk@ti.com, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v5 0/5]  Introduce PRU platform consumer API
Message-ID: <20230323070032.GO7501@atomide.com>
References: <20230323062451.2925996-1-danishanwar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230323062451.2925996-1-danishanwar@ti.com>
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* MD Danish Anwar <danishanwar@ti.com> [230323 06:25]:
> The Programmable Real-Time Unit and Industrial Communication Subsystem (PRU-ICSS
> or simply PRUSS) on various TI SoCs consists of dual 32-bit RISC cores
> (Programmable Real-Time Units, or PRUs) for program execution.

Thanks this series looks good to me now:

Reviewed-by: Tony Lindgren <tony@atomide.com>
