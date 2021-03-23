Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF75346902
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 20:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233132AbhCWT15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 15:27:57 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:43440 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232231AbhCWT1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 15:27:41 -0400
Received: from mac-pro.holtmann.net (p4fefce19.dip0.t-ipconnect.de [79.239.206.25])
        by mail.holtmann.org (Postfix) with ESMTPSA id A724ECECE9;
        Tue, 23 Mar 2021 20:35:18 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: [PATCH v1] Bluetooth: Return whether a connection is outbound
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210323115459.v1.1.I3f19b22d6eaaa182123e373a9fa1fa85105aba07@changeid>
Date:   Tue, 23 Mar 2021 20:27:39 +0100
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        Alain Michaud <alainm@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <3CE31319-DA8C-409E-852B-30C03D0C3174@holtmann.org>
References: <20210323115459.v1.1.I3f19b22d6eaaa182123e373a9fa1fa85105aba07@changeid>
To:     Yu Liu <yudiliu@google.com>
X-Mailer: Apple Mail (2.3654.60.0.2.21)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yu,

> When an MGMT_EV_DEVICE_CONNECTED event is reported back to the user
> space we will set the flags to tell if the established connection is
> outbound or not. This is useful for the user space to log better metrics
> and error messages.
> 
> Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
> Reviewed-by: Alain Michaud <alainm@chromium.org>
> 
> Signed-off-by: Yu Liu <yudiliu@google.com>
> ---
> 
> Changes in v1:
> - Initial change

please send a patch to describe the API change in doc/mgmt-api.txt first.

Regards

Marcel

