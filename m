Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1F2B1691D3
	for <lists+netdev@lfdr.de>; Sat, 22 Feb 2020 21:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbgBVUxz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 22 Feb 2020 15:53:55 -0500
Received: from mail1.bemta25.messagelabs.com ([195.245.230.65]:56621 "EHLO
        mail1.bemta25.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726828AbgBVUxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Feb 2020 15:53:54 -0500
Received: from [100.112.199.4] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-1.bemta.az-b.eu-west-1.aws.symcld.net id 52/3C-41576-7D4915E5; Sat, 22 Feb 2020 20:53:43 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCJsWRWlGSWpSXmKPExsVi93Vmku61KYF
  xBj87jSx+NqxntLj65B+zxcu1UhafFxlbHFwxmd3i1MMvLBbP3k9ntbjZOZ/J4vPZ+WwW33bf
  Z7N4dvwzk8Wxb6dZLT4828NocXnXHDaLRUuPAZVs0rM4tkDM4kDDaRaLS3eeszoIe+w82cLic
  e7wLxaPB/NbWTyuztrE5jFj/2dGj1+Tuxg9vh1cxewxbeY/Ro+3pw+xeDTcXcnqcePpOVaPay
  2+Ho2fTzN6XOk6yu7xeZNcAH8Ua2ZeUn5FAmtGz+4LbAUMFSCqgZGhi5GLQ0hgK6PEg81LmLs
  YOTmYBfQkbkydwgZi8woISpyc+YQFIq4tsWzha6AaDiBbTeJrVwlIWFjATuLdv3nsILaIgKrE
  1z0zWUFsNgEZiZ9Hd4PFWYDiN9//BhsvJKAo8XbdRqjxfhI/X5xng4k3N60AsyWA7KXX2lggb
  CuJbUva2SFsTYn175azg5wgIaAg8XmGMURYXuLjhRmMExgFZyF5YBaSB2YheWAWwgMLGFlWMV
  okFWWmZ5TkJmbm6BoaGOgaGhrpGlqa6Roam+slVukm6aWW6panFpfoGuollhfrFVfmJuek6OW
  llmxiBCaGlIIjnTsYf695r3eIUZKDSUmUV3diYJwQX1J+SmVGYnFGfFFpTmrxIUYTDg6Bzucf
  VjMKXDj78BOjwJUPn5qYpFjy8vNSlSR4LScD9QgWpaanVqRl5gCTGkybBAePkggvG8hI3uKCx
  NzizHSI1ClGS457T+YuYubYeHQekJy9ffEiZiGweVLivK9B5gmANGSU5sGNgyXeS4yyUsK8jA
  wMDEI8BalFuZklqPKvGMU5GJWEeRsmAU3hycwrgdv6CuggJqCDlDkCQA4qSURISTUw+TI5z+b
  5u7xIQUn/8Sbhz5GugXlSu1mZHk8qnRCefk5V/tXDvTf1eTh0FlrKqDwp+mBk8tFibYDz+ph2
  OTHpa8fftnyu8o/r3brYIMfh6sXj+t31U25/O7rRsMNm/rypId/u3jg7a27o8uzrmpxz9nQIL
  v/KfWmHX+kb7s4Jl66ck1UIKVeXWS7w++isqfnTfLccrHDVYOB2mjhDNGhmYypPTeAjxusWSb
  rTlZu3X197tGP/1EyzT1J7a41vGtatezWfv2S6ps5B5cfCxzbvnVqg/KZR198p9fHhhd/irlw
  My6i53li/uNx9wrXdmx/brjCbNfHj+pOV13SZdFcwV7xf6iK4JfrPhWMTGmKNY5RYijMSDbWY
  i4oTAfCoIaE3BAAA
X-Env-Sender: michael.larcher@rothof.de
X-Msg-Ref: server-12.tower-288.messagelabs.com!1582404820!1797956!5
X-Originating-IP: [62.245.153.98]
X-SYMC-ESS-Client-Auth: outbound-route-from=fail
X-StarScan-Received: 
X-StarScan-Version: 9.44.25; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 28940 invoked from network); 22 Feb 2020 20:53:42 -0000
Received: from host-62-245-153-98.customer.m-online.net (HELO Sport-Exchange.ROTHOF.local) (62.245.153.98)
  by server-12.tower-288.messagelabs.com with ECDHE-RSA-AES256-SHA encrypted SMTP; 22 Feb 2020 20:53:42 -0000
Received: from jmapnzin.host-stage-dns.com (188.165.89.95) by
 Sport-Exchange.ROTHOF.local (192.168.100.3) with Microsoft SMTP Server id
 14.3.123.3; Sat, 22 Feb 2020 21:53:32 +0100
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Description: Mail message body
Subject: Re: I have a business for you, if you are interested!
To:     Recipients <michael@ROTHOF.local>
From:   <michael@ROTHOF.local>
Date:   Sun, 23 Feb 2020 04:53:34 +0800
Reply-To: <lizawong@infohsbc.net>
Message-ID: <2cd0ee45-30f1-4b5b-8307-84e9badb9f6f@SPORT-EXCHANGE.ROTHOF.local>
X-Originating-IP: [188.165.89.95]
X-TM-AS-Product-Ver: SMEX-11.7.0.1065-8.500.1020-25246.005
X-TM-AS-Result: Yes-48.583700-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


