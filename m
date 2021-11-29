Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2D5E461CF3
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 18:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349752AbhK2Rsp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 29 Nov 2021 12:48:45 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:60941 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348618AbhK2Rqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 12:46:42 -0500
Received: from smtpclient.apple (p5b3d2e91.dip0.t-ipconnect.de [91.61.46.145])
        by mail.holtmann.org (Postfix) with ESMTPSA id 9813DCED2E;
        Mon, 29 Nov 2021 18:43:23 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.20.0.1.32\))
Subject: Re: [PATCH v6 1/2] bluetooth: Handle MSFT Monitor Device Event
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <CAGPPCLB7iJOWb8try5gR9GhC9-gZPzGvgBCeTG3ktNFEXtMQ3A@mail.gmail.com>
Date:   Mon, 29 Nov 2021 18:43:23 +0100
Cc:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth@vger.kernel.org,
        chromeos-bluetooth-upstreaming@chromium.org,
        Miao-chen Chou <mcchou@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <3C2ED65E-B71A-49DF-9C7D-7F8BA98ABF38@holtmann.org>
References: <20211121110853.v6.1.Ic0a40b84dee3825302890aaea690e73165c71820@changeid>
 <CAGPPCLB7iJOWb8try5gR9GhC9-gZPzGvgBCeTG3ktNFEXtMQ3A@mail.gmail.com>
To:     Manish Mandlik <mmandlik@google.com>
X-Mailer: Apple Mail (2.3693.20.0.1.32)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Manish,

> Friendly reminder to review this patch series.

you actually need to look for the kernel build robot comments and address them. In general I am not looking at patches where the kernel build robots finds issues.

Regards

Marcel

