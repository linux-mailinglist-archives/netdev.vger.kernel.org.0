Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 324F66F325F
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 16:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232621AbjEAO6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 10:58:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232281AbjEAO6C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 10:58:02 -0400
Received: from zeeaster.vergenet.net (zeeaster.vergenet.net [206.189.110.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E5D5109
        for <netdev@vger.kernel.org>; Mon,  1 May 2023 07:58:01 -0700 (PDT)
Received: from momiji.horms.nl (86-93-216-223.fixed.kpn.net [86.93.216.223])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by zeeaster.vergenet.net (Postfix) with ESMTPSA id 6F7272024B;
        Mon,  1 May 2023 14:57:59 +0000 (UTC)
Received: by momiji.horms.nl (Postfix, from userid 7100)
        id F318B9498E5; Mon,  1 May 2023 16:57:58 +0200 (CEST)
Date:   Mon, 1 May 2023 16:57:58 +0200
From:   Simon Horman <horms@kernel.org>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     jasowang@redhat.com, mst@redhat.com,
        virtualization@lists.linux-foundation.org, brett.creeley@amd.com,
        netdev@vger.kernel.org, drivers@pensando.io
Subject: Re: [PATCH v4 virtio 03/10] pds_vdpa: move enum from common to
 adminq header
Message-ID: <ZE/TdtU7kT3Nt2A/@vergenet.net>
References: <20230425212602.1157-1-shannon.nelson@amd.com>
 <20230425212602.1157-4-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230425212602.1157-4-shannon.nelson@amd.com>
Organisation: Horms Solutions BV
X-Virus-Scanned: clamav-milter 0.103.8 at zeeaster
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 02:25:55PM -0700, Shannon Nelson wrote:
> The pds_core_logical_qtype enum and IFNAMSIZ are not needed
> in the common PDS header, only needed when working with the
> adminq, so move them to the adminq header.
> 
> Note: This patch might conflict with pds_vfio patches that are
>       in review, depending on which patchset gets pulled first.
> 
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

