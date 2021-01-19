Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6680C2FAE41
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 02:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387646AbhASBJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 20:09:36 -0500
Received: from fox.pavlix.cz ([185.8.165.163]:58436 "EHLO fox.pavlix.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387580AbhASBJe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 20:09:34 -0500
Received: from [172.16.63.206] (unknown [217.30.64.218])
        by fox.pavlix.cz (Postfix) with ESMTPSA id 51AFFE72E2;
        Tue, 19 Jan 2021 02:08:51 +0100 (CET)
Subject: mdio: access c22 registers via debugfs
To:     Tobias Waldekranz <tobias@waldekranz.com>, netdev@vger.kernel.org
References: <20210116211916.8329-1-code@simerda.eu>
 <87h7ndker7.fsf@waldekranz.com>
From:   =?UTF-8?Q?Pavel_=c5=a0imerda?= <code@simerda.eu>
Message-ID: <204006a5-004e-03ce-6117-86f391d6aece@simerda.eu>
Date:   Tue, 19 Jan 2021 02:08:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <87h7ndker7.fsf@waldekranz.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tobias,

given the reasons stated in the mailing list, I'd like to discuss the situation off-list. I would be more than happy to join your effort and provide an OpenWRT package. I understand the motivation to reject that, and I do use it partially also for the “bad purpose” and therefore I'd like to solve it as consistently as possible.

I'm working with mv88e6xxx where c45 can be coded in c22 anyway, so I didn't care to implement it in the MDIO driver. I'd like to share with you the user space script I'm using to access both mv88e6xxx and direct PHY registers.

I see you're working with mv88e6xxx as well. Can you access all of the inderect registers up to multichip+indirect+paged/c45 registers even without the mv88e6xxx driver loaded, or not? I'm using this feature to bootstrap the switch and get it onto the network when the driver doesn't work yet.

I've seen a few new patches submitted to next-next regarding mv88e6393 and the lag support. I'm also going to explore MSTP and more. I published some of my changes that might not be accepted upstream any soon, or like this one, at all:

https://github.com/switchwrt

Regards,

Pavel
