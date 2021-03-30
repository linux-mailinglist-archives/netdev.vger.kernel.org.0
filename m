Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3311834DD5B
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 03:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbhC3BNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 21:13:50 -0400
Received: from mail2.directv.syn-alias.com ([69.168.106.50]:43456 "EHLO
        mail.directv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbhC3BNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 21:13:35 -0400
DKIM-Signature: v=1; a=rsa-sha1; d=wildblue.net; s=20170921; c=relaxed/simple;
        q=dns/txt; i=@wildblue.net; t=1617066814;
        h=From:Subject:Date:To:MIME-Version:Content-Type;
        bh=SYoRc8S8SDUVyZKqYCiGq8J4MxI=;
        b=uiQaQ5JxOToAmI3+OYUdOsDo8YWaj/alon9KtKt5kW1Rad5nDeAO5RcYJ1q5Hzc+
        T298BBGp5L0DwAlku124qB3TXZ6Nfzss58HIxpG1aqiZDPJ9nyTkAi25n72nPUks
        WECWmA1TtGgIUskhGJ8ilYiQGTLqWvejR2+s8sFMN2qmjvJ0xSVQq6pIBpvaUe3P
        KcX2k6ckD9GSI/VT7Ge5EOHOkd7R9j7RGfPhunIWD+UpOdbglW/6gdJAXHzdnu7t
        EuQ9paxMcODkvO8a+O2Y8SmvGQPmAvMxz4o/uuBX85YylqHqCowl8CP49z/4VQP2
        tXd1XYpY8Agx9lCw9prpuw==;
X-Authed-Username: aGVpbmVyY29uc3RydWN0aW9uQHdpbGRibHVlLm5ldA==
Received: from [10.80.118.2] ([10.80.118.2:37532] helo=md02.jasper.bos.sync.lan)
        by mail2.directv.syn-alias.com (envelope-from <heinerconstruction@wildblue.net>)
        (ecelerity 3.6.25.56547 r(Core:3.6.25.0)) with ESMTP
        id 5E/C9-06922-D3B72606; Mon, 29 Mar 2021 21:13:34 -0400
Date:   Mon, 29 Mar 2021 21:13:33 -0400 (EDT)
From:   Rowell Hambrick <heinerconstruction@wildblue.net>
Reply-To: rowellhamb@outlook.com
To:     lzhaonf@126.com
Message-ID: <295730056.44360564.1617066813766.JavaMail.zimbra@wildblue.net>
Subject: 
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.0.5.76]
X-Mailer: Zimbra 8.7.6_GA_1776 (zclient/8.7.6_GA_1776)
Thread-Index: WsdGahJ0QPuZ6ZcDRqcLkMcQpqxfLg==
Thread-Topic: 
X-Vade-Verditct: clean
X-Vade-Analysis: gggruggvucftvghtrhhoucdtuddrgeduledrudehledggeehucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuufgjpfetvefqtfdpggfktefutefvpdfqfgfvnecuuegrihhlohhuthemuceftddunecugfhmphhthicushhusghjvggtthculddutddmnecujfgurhepfffhrhfvkffugggtgfhiofhtsehtjegttdertdejnecuhfhrohhmpeftohifvghllhcujfgrmhgsrhhitghkuceohhgvihhnvghrtghonhhsthhruhgtthhiohhnseifihhluggslhhuvgdrnhgvtheqnecuggftrfgrthhtvghrnhepgfffudelvdeuteejheehjeeltedvjedvudfhieevjeefveeigefftdelleegfeevnecukfhppedutddrkedtrdduudekrddvpdduieehrddtrdehrdejieenucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepihhnvghtpedutddrkedtrdduudekrddvnedpmhgrihhlfhhrohhmpehhvghinhgvrhgtohhnshhtrhhutghtihhonhesfihilhgusghluhgvrdhnvghtnedprhgtphhtthhopehnvgifjhhinhhhrghisehvihhprdduieefrdgtohhmne
X-Vade-Client: VIASAT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Did you get my last mail
