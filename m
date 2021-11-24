Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6741D45B2CB
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 04:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240890AbhKXDxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 22:53:32 -0500
Received: from mail.loongson.cn ([114.242.206.163]:58044 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240875AbhKXDxc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 22:53:32 -0500
Received: from localhost.localdomain (unknown [111.9.175.10])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9DxeNJ3tp1hx9oAAA--.1299S2;
        Wed, 24 Nov 2021 11:50:21 +0800 (CST)
From:   Huang Pei <huangpei@loongson.cn>
To:     netdev@vger.kernel.org, ambrosehua@gmail.com
Cc:     linux-arch@vger.kernel.org
Subject: [PATCH V3]: bugfix
Date:   Wed, 24 Nov 2021 11:50:00 +0800
Message-Id: <20211124035004.7871-1-huangpei@loongson.cn>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf9DxeNJ3tp1hx9oAAA--.1299S2
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
        VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYe7k0a2IF6w4kM7kC6x804xWl14x267AK
        xVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGw
        A2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26r4j
        6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j6F4UM28EF7xvwVC2z280aVAFwI0_Gr
        1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Cr1j6rxdM2AIxVAIcxkEcVAq07x20xvE
        ncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I
        8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc2xS
        Y4AK67AK6r48MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
        8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUXVWU
        AwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
        0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Wr1j6rW3Jr1lIxAIcVC2z280aVAF
        wI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa
        7IU5NJ57UUUUU==
X-CM-SenderInfo: xkxd0whshlqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

V3:

+. submit two driver fix for warning message separately, and
it has already been accepted by netdev upstream

+. improve commit message

PS:

Does anyone has tx39 hardware? From tx39 kconfig, I can see it 
does NOT support High Memory, which is natural for old 32bit MIPS,
but I can not tell if it has dcache alias. My next patchset
depends on it

In-Reply-To: 


