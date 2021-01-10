Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A96AC2F0823
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 16:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727370AbhAJPfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 10:35:50 -0500
Received: from 13.mo1.mail-out.ovh.net ([178.33.253.128]:55924 "EHLO
        13.mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726554AbhAJPfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 10:35:47 -0500
X-Greylist: delayed 8399 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Jan 2021 10:35:46 EST
Received: from player772.ha.ovh.net (unknown [10.109.146.32])
        by mo1.mail-out.ovh.net (Postfix) with ESMTP id 7AEC51E82BE
        for <netdev@vger.kernel.org>; Sun, 10 Jan 2021 11:10:19 +0100 (CET)
Received: from RCM-web10.webmail.mail.ovh.net (ip-194-187-74-233.konfederacka.maverick.com.pl [194.187.74.233])
        (Authenticated sender: rafal@milecki.pl)
        by player772.ha.ovh.net (Postfix) with ESMTPSA id C810719EEDB67;
        Sun, 10 Jan 2021 10:10:08 +0000 (UTC)
MIME-Version: 1.0
Date:   Sun, 10 Jan 2021 11:10:08 +0100
From:   =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com
Subject: Re: [PATCH V2 net-next 1/3] dt-bindings: net: convert Broadcom
 Starfighter 2 binding to the json-schema
In-Reply-To: <20210109191957.1ef47d28@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210106213202.17459-1-zajec5@gmail.com>
 <20210109191957.1ef47d28@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Roundcube Webmail/1.4.3
Message-ID: <00fffaaaaa4b1120a6c71bca82172296@milecki.pl>
X-Sender: rafal@milecki.pl
X-Originating-IP: 194.187.74.233
X-Webmail-UserID: rafal@milecki.pl
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 15171219772339228314
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedujedrvdegledgudegucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepggffhffvufgjfhgfkfigihgtgfesthekjhdttderjeenucfhrhhomheptfgrfhgrlhgpofhilhgvtghkihcuoehrrghfrghlsehmihhlvggtkhhirdhplheqnecuggftrfgrthhtvghrnhepjeffudffgfejgfdvieegudekffefveehjeeuieekheduieduhedvieefudetheeinecukfhppedtrddtrddtrddtpdduleegrddukeejrdejgedrvdeffeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopehplhgrhigvrhejjedvrdhhrgdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomheprhgrfhgrlhesmhhilhgvtghkihdrphhlpdhrtghpthhtohepnhgvthguvghvsehvghgvrhdrkhgvrhhnvghlrdhorhhg
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-01-10 04:19, Jakub Kicinski wrote:
> On Wed,  6 Jan 2021 22:32:00 +0100 Rafał Miłecki wrote:
>> From: Rafał Miłecki <rafal@milecki.pl>
>> 
>> This helps validating DTS files. Only the current (not deprecated one)
>> binding was converted.
>> 
>> Minor changes:
>> 1. Dropped dsa/dsa.txt references
>> 2. Updated node name to match dsa.yaml requirement
>> 3. Fixed 2 typos in examples
>> 
>> The new binding was validated using the dt_binding_check.
>> 
>> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> 
> Applied, I trust you'll follow up promptly if Rob finds anything wrong
> with the DT parts :)

Promise! :)
