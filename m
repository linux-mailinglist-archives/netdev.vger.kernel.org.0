Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F28F436D66
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 00:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232242AbhJUWZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 18:25:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:37826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232261AbhJUWZf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 18:25:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A96561251;
        Thu, 21 Oct 2021 22:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634854999;
        bh=VJWVuXEmZv6SDnnqhklF0JsffKyacxUlkc+isD39bLY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=t6/jXm56n/ln7SUBiA0b48DaHxxsoAmGC1Bt6xh7xl/Cs7xypxAOelayhAxM6Y01R
         +5H0gtj2ENb7673gV5MNr0yk96fU6l8LbJHaTRLbhgSWzqQea50itR66KjSHgBKQw+
         XzqszbO9Yu8+fCpu3TbBCmex/5778cIe8oQynHdZWdfJnsH4jr2EIFgXYbbvwv4+6u
         J7DbDG90p5NIV/X3xoF9w1Ot3RJ91Jkjs4RmO+08gDmSkpSf1wUCww+IB7vCpWuPxR
         FoBNfTr3sQjaQcMhVZBBgsTjIoUCp3Wug6Yeq81GzA77li2wN6p9ZBnvAjCyYC1TJx
         m/5v83/+bNnUg==
Date:   Thu, 21 Oct 2021 15:23:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com
Subject: Re: [PATCH 00/14] net: wwan: t7xx: PCIe driver for MediaTek M.2
 modem
Message-ID: <20211021152317.3de4d226@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211021202738.729-1-ricardo.martinez@linux.intel.com>
References: <20211021202738.729-1-ricardo.martinez@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Oct 2021 13:27:24 -0700 Ricardo Martinez wrote:
> t7xx is the PCIe host device driver for Intel 5G 5000 M.2 solution
> which is based on MediaTek's T700 modem to provide WWAN connectivity.

It needs to build cleanly with W=1, and have no kdoc warnings
(scripts/kernel-doc -none).
