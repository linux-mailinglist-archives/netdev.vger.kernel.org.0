Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64B4D67E961
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 16:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234442AbjA0PZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 10:25:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjA0PZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 10:25:20 -0500
Received: from alexa-out-sd-01.qualcomm.com (alexa-out-sd-01.qualcomm.com [199.106.114.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D95B37B434;
        Fri, 27 Jan 2023 07:25:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1674833119; x=1706369119;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=zO8nVNBHWCsW7pm+iq5qvzD/WuhnugOCzKAoOIfNKP0=;
  b=wJwnypwm9K0p8ZYtn3rNJuJOeP+GcAtFq0cMEoGc3mpHv4PEHEOi34mR
   upWoO2pDFsKJK9A+JnN6U61kJ8O6RDvoldX/HlSyTOr6r52EQ0mPM/64Q
   I+grKvu9UwRr3nQaM2ctKXU8WvMjDvtfKWYxUfY7HwWkwAkQ/pK31mJqP
   U=;
Received: from unknown (HELO ironmsg-SD-alpha.qualcomm.com) ([10.53.140.30])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 27 Jan 2023 07:25:19 -0800
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.45.79.139])
  by ironmsg-SD-alpha.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2023 07:25:19 -0800
Received: from hu-mojha-hyd.qualcomm.com (10.80.80.8) by
 nasanex01c.na.qualcomm.com (10.45.79.139) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Fri, 27 Jan 2023 07:25:16 -0800
From:   Mukesh Ojha <quic_mojha@quicinc.com>
To:     <rdunlap@infradead.org>
CC:     <corbet@lwn.net>, <daniel.m.jordan@oracle.com>,
        <linux-crypto@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <olteanv@gmail.com>, <steffen.klassert@secunet.com>
Subject: Re: [PATCH 05/35] Documentation: core-api: correct spelling
Date:   Fri, 27 Jan 2023 20:55:07 +0530
Message-ID: <1674833107-10526-1-git-send-email-quic_mojha@quicinc.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <20230127064005.1558-6-rdunlap@infradead.org>
References: <20230127064005.1558-6-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01c.na.qualcomm.com (10.45.79.139)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>Correct spelling problems for Documentation/core-api/ as reported
>by codespell.

>Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>Cc: Vladimir Oltean <olteanv@gmail.com>
>Cc: netdev@vger.kernel.org
>Cc: Steffen Klassert <steffen.klassert@secunet.com>
>Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
>Cc: linux-crypto@vger.kernel.org
>Cc: Jonathan Corbet <corbet@lwn.net>
>Cc: linux-doc@vger.kernel.org

Reviewed-by: Mukesh Ojha <quic_mojha@quicinc.com>

-Mukesh
