Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2DC048A531
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 02:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344326AbiAKBnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 20:43:46 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48732 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243764AbiAKBnq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 20:43:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9671A61474
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 01:43:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4966C36AE5;
        Tue, 11 Jan 2022 01:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641865425;
        bh=8RdBpXBggpCxOTGXCc+9oy4ZR62adpo5xljlKObwaUY=;
        h=From:To:Cc:Subject:Date:From;
        b=KiKPX8NMB6qN2Xo5vhYfpEDTaq+1ei79wv9N5mOoqdGnrarntpYqzpUXpBMMXPCEb
         vfJPHvqAWxal054NkdmhDxBtH/wTPhNDkz4pzjJmDqe2AC6O/0ZFsvMuBzNwt2yMHx
         zCGtl91P8MjjbhGUE6ybFn6OdvibecFaAZMfIZK4k8fAF+i4tBqhpRzTdE5Vx6vAkp
         4ziWczZrfleAuxpAtTxJZy4tO6FE2X3wwbuhsav4k8pPn2WdvBljgEVlszS0lgtJX9
         rAjzysbufbpT+kRK2BC7CnedSEi1wX6es+T6LBqB26Emd1+clJPTK4mirgcdEX4d+l
         LlIuAhw9Ceylg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next 00/17] mlx5 updates 2022-01-10
Date:   Mon, 10 Jan 2022 17:43:18 -0800
Message-Id: <20220111014335.178121-1-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Hi Jakub,

This series is mostly refactoring and code improvements in mlx5.
For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.


