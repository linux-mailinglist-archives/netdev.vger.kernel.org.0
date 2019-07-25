Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F63574792
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 08:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727682AbfGYG7D convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 25 Jul 2019 02:59:03 -0400
Received: from ecs-90-84-246-155.compute.prod-cloud-ocb.orange-business.com ([90.84.246.155]:33991
        "EHLO mail.numalliance.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726479AbfGYG7D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 02:59:03 -0400
X-Greylist: delayed 523 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Jul 2019 02:59:02 EDT
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mail.numalliance.com (Postfix) with ESMTP id 6B5782119A1C
        for <netdev@vger.kernel.org>; Thu, 25 Jul 2019 08:50:18 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at mail.numalliance.com
Received: from mail.numalliance.com ([127.0.0.1])
        by localhost (mail.numalliance.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ymPkR1gEzDkd for <netdev@vger.kernel.org>;
        Thu, 25 Jul 2019 08:50:09 +0200 (CEST)
Received: from [192.168.0.67] (unknown [192.168.0.67])
        (Authenticated sender: sancelot@numalliance.com)
        by mail.numalliance.com (Postfix) with ESMTPSA id CBE4C23E5299
        for <netdev@vger.kernel.org>; Thu, 25 Jul 2019 08:50:08 +0200 (CEST)
To:     netdev@vger.kernel.org
From:   =?UTF-8?Q?St=c3=a9phane_Ancelot?= <sancelot@numalliance.com>
Subject: TSN - tc usage for a tbs setup
Message-ID: <43c8c7bd-f281-a4dc-badc-9672aaccbd6a@numalliance.com>
Date:   Thu, 25 Jul 2019 08:50:08 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I am trying to setup my network queue for offline time based configuration.

initial setup is :

tc qdisc show dev eth1:

qdisc mq 0: root

qdisc pfifo_fast 0: parent :1 bands 3 priomap  1 2 2 2 1 2 0 0 1 1 1 1 1 
1 1 1


I won't need pfifo , I have to send one frame at a precise xmit time 
(high prio), and then maybe some other frames (with low priority)


I want to setup offload time based  xmit.

/sbin/tc qdisc add dev eth1 root handle 100:1 etf delta 100000 clockid 
CLOCK_REALTIME offload

replies with

RTNETLINK answers: Invalid argument


What is wrong ?

Regards,

S.Ancelot

