Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED5626D2E4C
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 07:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233462AbjDAFJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 01:09:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjDAFJM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 01:09:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64FFAFF09
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 22:09:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0359860A4D
        for <netdev@vger.kernel.org>; Sat,  1 Apr 2023 05:09:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3190C433D2;
        Sat,  1 Apr 2023 05:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680325750;
        bh=ynARzhiFjG1/BAgftgsERxcdrcufO6bhmRFExSSdjQU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=V0JY3vremNYRJ3G+SVo6q3RJFnuh0BeFkWlHnHllojqg7GrWF9BP5TIbEMs/hErt+
         tScuq3mh6OhsDEDgy921sW0UY+kfl5k+fTSRfqZouGtfy34xu4PkkPT8Tj8d6sX6Yy
         tddf9doVU9FiJRdCvuO03zrjq97MHu4RtrBwhOITxgWpCG+KFkfi0Zl/J9Fh6DtCav
         mgtNWX8aoQx1UuqR36Gtr6/7ajYIaz9UI0S612izbYJh5JsDtlKiW3+R9rY33+o8sc
         RWJaEMhf3yJSmeBNHLHmDX4fS1t1ILb37Snln/MPSGg94BVtms8OLBmeLwd7OQtvLw
         GBo1+4ges0zfQ==
Date:   Fri, 31 Mar 2023 22:09:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     <brett.creeley@amd.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <drivers@pensando.io>, <leon@kernel.org>,
        <jiri@resnulli.us>
Subject: Re: [PATCH v8 net-next 07/14] pds_core: add FW update feature to
 devlink
Message-ID: <20230331220908.2a2fa0bc@kernel.org>
In-Reply-To: <20230330234628.14627-8-shannon.nelson@amd.com>
References: <20230330234628.14627-1-shannon.nelson@amd.com>
        <20230330234628.14627-8-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Mar 2023 16:46:21 -0700 Shannon Nelson wrote:
> Add in the support for doing firmware updates.  Of the two
> main banks available, a and b, this updates the one not in
> use and then selects it for the next boot.

My memory is hazy but I think you needed similar functionality in ionic
and deferred implementing proper uAPI for it? And now we have another
driver with the same problem?
