Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7D119820C
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 19:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728868AbgC3RRT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 13:17:19 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39798 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726981AbgC3RRT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 13:17:19 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C10BA15BFFFEF;
        Mon, 30 Mar 2020 10:17:18 -0700 (PDT)
Date:   Mon, 30 Mar 2020 10:17:17 -0700 (PDT)
Message-Id: <20200330.101717.540859393139624676.davem@davemloft.net>
To:     jiri@mellanox.com
CC:     netdev@vger.kernel.org
Subject: mlxsw warnings in net-next
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Mar 2020 10:17:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpKaXJpIHBsZWFzZSBsb29rIGludG8gdGhpczoNCg0KZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVs
bGFub3gvbWx4c3cvc3BlY3RydW1fcHRwLmM6IEluIGZ1bmN0aW9uIKFtbHhzd19zcF9wdHBfZ2V0
X21lc3NhZ2VfdHlwZXOiOg0KZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4c3cvc3Bl
Y3RydW1fcHRwLmM6OTE1OjI6IHdhcm5pbmc6IGVudW1lcmF0aW9uIHZhbHVlIKFfX0hXVFNUQU1Q
X1RYX0NOVKIgbm90IGhhbmRsZWQgaW4gc3dpdGNoIFstV3N3aXRjaF0NCiAgc3dpdGNoICh0eF90
eXBlKSB7DQogIF5+fn5+fg0KZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4c3cvc3Bl
Y3RydW1fcHRwLmM6OTI3OjI6IHdhcm5pbmc6IGVudW1lcmF0aW9uIHZhbHVlIKFfX0hXVFNUQU1Q
X0ZJTFRFUl9DTlSiIG5vdCBoYW5kbGVkIGluIHN3aXRjaCBbLVdzd2l0Y2hdDQogIHN3aXRjaCAo
cnhfZmlsdGVyKSB7DQogIF5+fn5+fg0KDQpUaGFua3MuDQo=
