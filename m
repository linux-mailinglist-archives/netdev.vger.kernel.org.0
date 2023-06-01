Return-Path: <netdev+bounces-7020-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C72B7193B2
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 08:58:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 740C01C20FD0
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 06:58:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC5455392;
	Thu,  1 Jun 2023 06:58:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8B31FDA
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 06:58:43 +0000 (UTC)
Received: from cstnet.cn (smtp80.cstnet.cn [159.226.251.80])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA6EE44;
	Wed, 31 May 2023 23:58:31 -0700 (PDT)
Received: from localhost.localdomain (unknown [124.16.138.125])
	by APP-01 (Coremail) with SMTP id qwCowACHj+uCQXhk1KJMCQ--.36089S2;
	Thu, 01 Jun 2023 14:58:12 +0800 (CST)
From: Jiasheng Jiang <jiasheng@iscas.ac.cn>
To: kuba@kernel.org
Cc: davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	davthompson@nvidia.com,
	asmaa@nvidia.com,
	mkl@pengutronix.de,
	limings@nvidia.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: Re: [PATCH] mlxbf_gige: Add missing check for platform_get_irq
Date: Thu,  1 Jun 2023 14:58:08 +0800
Message-Id: <20230601065808.1137-1-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowACHj+uCQXhk1KJMCQ--.36089S2
X-Coremail-Antispam: 1UD129KBjvJXoW7ur13KF4kArWxXw48uF4UArb_yoW8Ww1rp3
	4rKw1furW8Jr1fKw4kCw15ua4Yya98Cr15Xr1v9a1rZasxXrn5KFyFqr4avryUGa4F939r
	tFsI9ry8Kw47Za7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Cr
	1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E
	8cxan2IY04v7MxkIecxEwVAFwVW8AwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
	VjvjDU0xZFpf9x0JU-J5rUUUUU=
X-Originating-IP: [124.16.138.125]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu,  1 Jun 2023 14:27:21 +0800 Jakub Kicinski wrote:
> On Thu,  1 Jun 2023 14:19:08 +0800 Jiasheng Jiang wrote:
>> Add the check for the return value of the platform_get_irq and
>> return error if it fails.
>> 
>> Fixes: f92e1869d74e ("Add Mellanox BlueField Gigabit Ethernet driver")
>> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> 
> BTW I looked thru my sent messages and I complained to you about not
> CCing people at least twice before. Please start paying attention or
> we'll stop paying attention to your patches.

According to the documentation of submitting patches
(Link: https://docs.kernel.org/process/submitting-patches.html),
I used "scripts/get_maintainer.pl" to gain the appropriate recipients
for my patch.
However, the "limings@nvidia.com" is not contained in the following list.

"David S. Miller" <davem@davemloft.net> (maintainer:NETWORKING DRIVERS)
Eric Dumazet <edumazet@google.com> (maintainer:NETWORKING DRIVERS)
Jakub Kicinski <kuba@kernel.org> (maintainer:NETWORKING DRIVERS,commit_signer:5/6=83%,authored:1/6=17%,removed_lines:1/20=5%)
Paolo Abeni <pabeni@redhat.com> (maintainer:NETWORKING DRIVERS)
Asmaa Mnebhi <asmaa@nvidia.com> (commit_signer:4/6=67%)
David Thompson <davthompson@nvidia.com> (commit_signer:4/6=67%,authored:4/6=67%,added_lines:94/99=95%,removed_lines:19/20=95%)
Marc Kleine-Budde <mkl@pengutronix.de> (commit_signer:1/6=17%)
netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
linux-kernel@vger.kernel.org (open list)

There may be a problem with the script.
The best way is to fix it.

Thanks,
Jiang


