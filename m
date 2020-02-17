Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72C2F1607E8
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 03:02:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgBQCC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 21:02:28 -0500
Received: from mail3-bck.iservicesmail.com ([217.130.24.85]:34625 "EHLO
        mail3-bck.iservicesmail.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726251AbgBQCC2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 21:02:28 -0500
IronPort-SDR: sER5Kcjvg6O91itjVXWk9DvY7FrHS3pOsQKcLBjprXKCsqZ+5t+9/D81E1MrakHZTJQCgo7gSr
 l7u2/pSvD0Ag==
IronPort-PHdr: =?us-ascii?q?9a23=3AKE8mBBEZw2Nw6qav+7tcz51GYnF86YWxBRYc79?=
 =?us-ascii?q?8ds5kLTJ78ocuwAkXT6L1XgUPTWs2DsrQY0raQ7P2rAj1IyK3CmU5BWaQEbw?=
 =?us-ascii?q?UCh8QSkl5oK+++Imq/EsTXaTcnFt9JTl5v8iLzG0FUHMHjew+a+SXqvnYdFR?=
 =?us-ascii?q?rlKAV6OPn+FJLMgMSrzeCy/IDYbxlViDanbr5+MRq7oR/Tu8QWjodvJKI8wQ?=
 =?us-ascii?q?bVr3VVfOhb2WxnKVWPkhjm+8y+5oRj8yNeu/Ig885PT6D3dLkmQLJbETorLX?=
 =?us-ascii?q?k76NXkuhffQwSP4GAcUngNnRpTHwfF9hD6UYzvvSb8q+FwxTOVPczyTbAzRD?=
 =?us-ascii?q?Si86JmQwLmhSsbKzI09nzch8pth6xZvR2hvQRyzYDUboGPKvRwfb7TctwGSm?=
 =?us-ascii?q?RORctRSy5MDZ+gY4cTE+YNI+BVpJT9qVsUqhu+ABGhCvnxxT9UmHD2x7Ax3O?=
 =?us-ascii?q?QmEQHA0wwrAtUDsGzTrNXvKKcdS/u4zLTOzTXCdPNWxS3955LVfR87u/2MXK?=
 =?us-ascii?q?5wfNPXxEIyFA3Flk2dpZL4Mz6XzOgBrmaW4/Z6We6xhGMrsQ98rzipy8wxkI?=
 =?us-ascii?q?fGnJgVxUrB9ShhxYY1IsC3R1BjbN6/FZtQqzmaN4xrQsM+W21ouDg1yrkBuZ?=
 =?us-ascii?q?OjeSgF0pUnxxrFa/OZd4iE/h3uWPyPITd/mX1qYry/hxG08Ue+0OHzSNK03E?=
 =?us-ascii?q?5LripDjNbMqmgA2wLO5sWFUPdx40ms1SqV2wzN5exIO045mKrDJ54k2LEwl5?=
 =?us-ascii?q?4TsUrZHi/xnUX7lLeWdkI++ui08evqeajmppmdN49vlgH+KL4hldGlDugiMw?=
 =?us-ascii?q?gOQ3CX+f6g27374U35XLJKg+UwkqbHrJDVONoUprCiDg9L3YYs9Qy/Ay2l0N?=
 =?us-ascii?q?sGh3kHKkxKeBadg4juIVHOL6OwMfDqhVmwnDp17+7JM6enAZjXKHXH1rD7cu?=
 =?us-ascii?q?VH5lZY2TY0mOhS+59OQo4GJv27Dlf8qNHCERg/PAy3w/3tA/1y04ofXSSEBa?=
 =?us-ascii?q?rPY43Itlrd3u8zLvPEW4gTt36pM/8/+/fGkHk4gkMHdKWgm5oLPiPrVs96Kl?=
 =?us-ascii?q?mUNCK/yuwKFn0H61Iz?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2HOOADy80lelyMYgtlmgkOBPgIBgVV?=
 =?us-ascii?q?SIBKMY4ZsVAZzH4NDhlKEEYEFgQCDM4YHEwyBWw0BAQEBATUCBAEBhECCBCQ?=
 =?us-ascii?q?8Ag0CAw0BAQYBAQEBAQUEAQECEAEBAQEBCBYGhXOCOyKDcCAPOUoMQAEOAYN?=
 =?us-ascii?q?XgksBAQoprTwNDQKFHoJPBAqBCIEbI4E2AwEBjCEaeYEHgSMhgisIAYIBgn8?=
 =?us-ascii?q?BEgFugkiCWQSNUhIhiUWYNIFqWgSWa4I5AQ+IFoQ3A4JaD4ELgx2DCYFnhFK?=
 =?us-ascii?q?Bf59mhBRXgSBzcTMaCDCBbhqBIE8YDY43jisCQIEXEAJPi0mCMgEB?=
X-IPAS-Result: =?us-ascii?q?A2HOOADy80lelyMYgtlmgkOBPgIBgVVSIBKMY4ZsVAZzH?=
 =?us-ascii?q?4NDhlKEEYEFgQCDM4YHEwyBWw0BAQEBATUCBAEBhECCBCQ8Ag0CAw0BAQYBA?=
 =?us-ascii?q?QEBAQUEAQECEAEBAQEBCBYGhXOCOyKDcCAPOUoMQAEOAYNXgksBAQoprTwND?=
 =?us-ascii?q?QKFHoJPBAqBCIEbI4E2AwEBjCEaeYEHgSMhgisIAYIBgn8BEgFugkiCWQSNU?=
 =?us-ascii?q?hIhiUWYNIFqWgSWa4I5AQ+IFoQ3A4JaD4ELgx2DCYFnhFKBf59mhBRXgSBzc?=
 =?us-ascii?q?TMaCDCBbhqBIE8YDY43jisCQIEXEAJPi0mCMgEB?=
X-IronPort-AV: E=Sophos;i="5.70,450,1574118000"; 
   d="scan'208";a="337904923"
Received: from mailrel04.vodafone.es ([217.130.24.35])
  by mail02.vodafone.es with ESMTP; 17 Feb 2020 03:02:15 +0100
Received: (qmail 29090 invoked from network); 17 Feb 2020 01:53:15 -0000
Received: from unknown (HELO 192.168.1.163) (mariapazos@[217.217.179.17])
          (envelope-sender <porta@unistrada.it>)
          by mailrel04.vodafone.es (qmail-ldap-1.03) with SMTP
          for <netdev@vger.kernel.org>; 17 Feb 2020 01:53:15 -0000
Date:   Mon, 17 Feb 2020 02:53:14 +0100 (CET)
From:   Peter Wong <porta@unistrada.it>
Reply-To: Peter Wong <peterwonghkhsbc@gmail.com>
To:     netdev@vger.kernel.org
Message-ID: <5943196.43957.1581904395090.JavaMail.cash@217.130.24.55>
Subject: Investment opportunity
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings,
Please check the attached email for a buisness proposal to explore.
Looking forward to hearing from you for more details.
Sincerely: Peter Wong




----------------------------------------------------
This email was sent by the shareware version of Postman Professional.

