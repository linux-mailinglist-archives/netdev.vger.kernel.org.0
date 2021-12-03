Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D84D446702F
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 03:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378230AbhLCCul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 21:50:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378218AbhLCCuk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 21:50:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76ED7C06174A;
        Thu,  2 Dec 2021 18:47:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 119CC62775;
        Fri,  3 Dec 2021 02:47:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00388C00446;
        Fri,  3 Dec 2021 02:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638499635;
        bh=SzRDDa9c6PtEphb+1OK8jXRhKNO0W+uy+jB5FALjy6s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WmL8NC3Vg10qxWLWiF/ifRzdihaVcrnNTO7/vShEitsh/zSubrafXYRx/KsBCh2o3
         y1YhLY//eDCk3FmjP1ly8bRU3FliuUtn/RueyXlAySU+v2NNcFXRenly5EXr6FHS1m
         b9NBzsn9bNKI2gtXbLIB3Wz5sw9LtnynTmmoTfC5OkTzSq2YNT7bcF+OVASMR8BEaY
         VaVVBCrpxggqIZnI90EtYIzbf5KN02fjAyhZLPYlQx5LsQZyNqR1tm6KJHgu8IHiHC
         XosUjntUqUc4NIeHhDiL7mpqa22uGGAmUbc2Qwb6hEMH6HhMBldyvDowE6tGV2Ejad
         AUuHGufpvCq9A==
Date:   Thu, 2 Dec 2021 18:47:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Li Zhijian <zhijianx.li@intel.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Davide Caratti <dcaratti@redhat.com>, shuah@kernel.org,
        linux-kselftest@vger.kernel.org, lizhijian@cn.fujitsu.com,
        linux-kernel@vger.kernel.org, lkp@intel.com, philip.li@intel.com,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] selftests/tc-testing: add exit code
Message-ID: <20211202184713.4afbdf26@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <236a81d3-db14-902f-8833-377ec0a9b7da@intel.com>
References: <20211117054517.31847-1-zhijianx.li@intel.com>
        <YZTDcjv4ZPXv8Oaz@dcaratti.users.ipa.redhat.com>
        <20211117060535.1d47295a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <4ed23cd5-f4a1-aa70-183f-fbea407c19ee@mojatatu.com>
        <20211117084854.0d44d64b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <d0c32c34-b0a4-ce1e-35d6-1894222e825a@mojatatu.com>
        <236a81d3-db14-902f-8833-377ec0a9b7da@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 3 Dec 2021 10:21:31 +0800 Li Zhijian wrote:
> CCed netdev

Please repost the patches.

