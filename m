Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4AF310AF8B
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 13:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfK0M3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 07:29:23 -0500
Received: from mail.cra.cz ([82.99.169.135]:32321 "EHLO mail.cra.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726383AbfK0M3X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Nov 2019 07:29:23 -0500
Received: from STSVMEXCH01.INT.CRA.CZ (192.168.130.210) by
 STSVMEXCH03.INT.CRA.CZ (192.168.130.211) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 27 Nov 2019 13:29:20 +0100
Received: from localhost.localdomain (192.168.44.2) by STSVMEXCH01.INT.CRA.CZ
 (192.168.130.210) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Wed, 27 Nov 2019 13:29:20 +0100
Subject: compat/devlink/mode is not present after installing
 linux-generic-hwe-18.04-edge
References: <10ad0e50-5753-cd42-e26d-d635a263084e@radiokomunikace.cz>
To:     <netdev@vger.kernel.org>
From:   Koukal Petr <p.koukal@radiokomunikace.cz>
X-Forwarded-Message-Id: <10ad0e50-5753-cd42-e26d-d635a263084e@radiokomunikace.cz>
Message-ID: <f9619b66-da85-a1e3-941d-dadde39718fc@radiokomunikace.cz>
Date:   Wed, 27 Nov 2019 13:29:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <10ad0e50-5753-cd42-e26d-d635a263084e@radiokomunikace.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

compat/devlink/mode is not present after installing 
linux-generic-hwe-18.04-edge

After installing linux-generic-hwe-18.04-edge
cannot set "switchdev" for vif interface when configuring asap2 SRIOV 
networking.

Previously, /sys/class/net/{device}/compat/devlink/mode was available.


Thank you very much for your help.
Petr

