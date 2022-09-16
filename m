Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8015BB44D
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 00:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbiIPWKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 18:10:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbiIPWKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 18:10:50 -0400
X-Greylist: delayed 1803 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 16 Sep 2022 15:10:48 PDT
Received: from phjyjlzx.tgpchicks.com (unknown [85.217.145.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C22C9A61D8
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 15:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed/relaxed; s=dkim; d=tgpchicks.com;
 h=Reply-To:From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding; i=zaa.hea@tgpchicks.com;
 bh=53L9s3P2/EOaZ2sxBbxl+ASjrrQ=;
 b=wY1Tsq15RwCZbcKSYZX++bShXNHjCMMV6PQkoewtaam6l1SOWjTz1C4EsW4PnJNORgLfyBdVYdqN
   eQpvABJpuNRIffFHP1JpG3FuSlWBTcr0+g+N0gZf6YWq/phr7RmJcNAThNbz5A5xlslDqfZfXZmL
   LMC1i/yYZnvcoXlD6TzYR4kVOAQ64j4I7fvZCmCJ1Oqr4DjEx6/h1Alr3k8y119o9t/+CE8gNnYB
   Y7Vqg8Cmddcr0nm0/TjKR+bijFJKZDZ+WpsD0JH3xVddgh0l3M1iZY7AlXee/UKlFobWxnYn0dt3
   axohzuO17BMoW5BRi0ZKTNyTO/QeHiN5bC29vQ==
DomainKey-Signature: a=rsa-sha1; c=nofws; q=dns; s=dkim; d=tgpchicks.com;
 b=DCqo8+sfkBM4lcvQYvXD5Ec+Ai2bFt6nvQ7LdXKgUclh/u1g4Em4M30ySaivzw1a4Gti/EJ+exOn
   xEreSTqzFtjjy4hDkgCBfu1CUG+D+IhrfOrkSN0d+4VQkmT9X2Dpgz1Y0jD7Gj3sxYjdzViLPauU
   NlWDbCedYyU3djT7ooCRxwQijYW+I3csmosleGma9PtXQE1qwfXC2A+fhJK6T7zBJg1G0XsWDEp8
   wdsaF9hioTwArUdjFN5usIo40xHTuhYglSo6QoZHy9XeBWYsqqdTrGB4J9MYwNeCDC8cp0w3QnW+
   Q2yLKQcCxDK+E5i4Ns4htvOGOSZzbjAViIopDQ==;
Reply-To: webster_donation@zohomail.com
From:   <zaa.hea@tgpchicks.com>
To:     netdev@vger.kernel.org
Subject: Congratulations!!!
Date:   16 Sep 2022 23:40:43 +0200
Message-ID: <20220916234043.F9C754A77CE8AA90@tgpchicks.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=7.5 required=5.0 tests=BAYES_95,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,LOTS_OF_MONEY,RDNS_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_ABUSE_SURBL,URIBL_BLACK,XFER_LOTSA_MONEY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: *  1.7 URIBL_BLACK Contains an URL listed in the URIBL blacklist
        *      [URIs: tgpchicks.com]
        *  3.0 BAYES_95 BODY: Bayes spam probability is 95 to 99%
        *      [score: 0.9547]
        *  1.2 URIBL_ABUSE_SURBL Contains an URL listed in the ABUSE SURBL
        *      blocklist
        *      [URIs: tgpchicks.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.8 RDNS_NONE Delivered to internal network by a host with no rDNS
        *  1.0 XFER_LOTSA_MONEY Transfer a lot of money
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Six hundred thousand dollars has been donated to you by Tammy and=20
Cliff Webster, who won a jackpot-winning Powerball ticket of=20
$316.3 Million on January 5, 2022.Reply to this email for more=20
information:
