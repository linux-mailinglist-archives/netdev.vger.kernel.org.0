Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 655FA1F813D
	for <lists+netdev@lfdr.de>; Sat, 13 Jun 2020 08:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgFMGRZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jun 2020 02:17:25 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:54216 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726290AbgFMGRY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Jun 2020 02:17:24 -0400
Received: from marcel-macpro.fritz.box (p5b3d2638.dip0.t-ipconnect.de [91.61.38.56])
        by mail.holtmann.org (Postfix) with ESMTPSA id DE967CED10;
        Sat, 13 Jun 2020 08:27:12 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH v2 1/7] Bluetooth: Add definitions for advertisement
 monitor features
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <CABmPvSE=eX_MqAWvgvOo9B6D+5Y0SzedAbRxrKmopvV+DTo5MQ@mail.gmail.com>
Date:   Sat, 13 Jun 2020 08:17:22 +0200
Cc:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>,
        Alain Michaud <alainm@chromium.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Manish Mandlik <mmandlik@chromium.org>,
        Michael Sun <michaelfsun@google.com>,
        Yoni Shavit <yshavit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <6E7BEC8E-D158-4990-A499-B38BE21FD80D@holtmann.org>
References: <20200603160058.v2.1.I636f906bf8122855dfd2ba636352bbdcb50c35ed@changeid>
 <2097432F-C4FA-4166-A221-DAE82B4A0C31@holtmann.org>
 <CABmPvSHKfS3fCfLzKCLAmf2p_JUYSkRrSfdkePVaHXSrLrXpbA@mail.gmail.com>
 <550BD45A-FE50-48C1-91CB-470D157A728B@holtmann.org>
 <CABmPvSE=eX_MqAWvgvOo9B6D+5Y0SzedAbRxrKmopvV+DTo5MQ@mail.gmail.com>
To:     Miao-chen Chou <mcchou@chromium.org>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Miao-chen,

> The name in the mgmt-api.txt doc is "Add Advertisement Patterns
> Monitor Command", and Luiz changed the name from
> MGMT_OP_ADD_ADV_PATTERNS_MONITOR to MGMT_OP_ADD_ADV_MONITOR before
> applied. So we either change the doc or change the header file to
> match. Based on the outcome I may need to change the name in mgmt.h in
> the kernel patch.

we change the mgmt.h to match the documentation.

Regards

Marcel

