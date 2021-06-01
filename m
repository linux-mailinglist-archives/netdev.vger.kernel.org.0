Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DEF5396C1B
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 06:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbhFAEZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 00:25:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:46252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229460AbhFAEZn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 00:25:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADB70611BE;
        Tue,  1 Jun 2021 04:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622521443;
        bh=jp50rspU3gtjJ7KHtdKj3CbWgVc/CR9O+EemLeRSjwk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pCLKjBRnj7z38JrxgbOcuhLQE1sczVq4HpaidfjIlJZQ0XKPNzQo5/+RUIrjeERKG
         mmecV03uU1gdaVB5j27czvQ0hUytHBAvFih1g9crPq/QKNn+b3cdZPD4LIf2nR41va
         hD3bgmIE0zCAXtLcth9olB2XERd8Iyw0jRlbt7Zq2uwQJ0tAHYjsYSaFy442UeopC3
         lWpKkE3mJZFQLePge1dTdpyiTA5dZI2RTXYo/o+HPLSNm9K5vTSpKjFxAeqDFB1pMG
         pnaJYFl/yo6QUE0D595I3axS4BLAbaVuTU6F7uSCfoOAUwiasrL+EY5O1Lly3ONofg
         8grfT5ZnF3mmQ==
Date:   Mon, 31 May 2021 21:24:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Karthik Sundaravel <ksundara@redhat.com>
Cc:     Parav Pandit <parav@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "karthik.sundaravel@gmail.com" <karthik.sundaravel@gmail.com>,
        Christophe Fontaine <cfontain@redhat.com>,
        Veda Barrenkala <vbarrenk@redhat.com>,
        Vijay Chundury <vchundur@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH 0/1] net-next: Port Mirroring support for SR-IOV
Message-ID: <20210531212401.205c6d06@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CAPh+B4Jhpwzcv=hyufYRhNfH+=DqqJkMGaJVMWswVAk9iZ_gKw@mail.gmail.com>
References: <ksundara@redhat.com>
        <20210527103318.801175-1-ksundara@redhat.com>
        <BY5PR12MB43223DDB8011260DD65B9405DC239@BY5PR12MB4322.namprd12.prod.outlook.com>
        <CAPh+B4Jhpwzcv=hyufYRhNfH+=DqqJkMGaJVMWswVAk9iZ_gKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 31 May 2021 13:12:04 +0530 Karthik Sundaravel wrote:
> 1. While iproute and switchdev may be similar in their actions for
> port mirroring, they both have unique use-cases for it, switchdev uses
> it for flow replication and iproute uses it for port/device tracking.
> 2. Also some legacy devices do not support switchdev, and iproute
> provides a means of a port mirroring solution that covers a wide range
> of Network Interface Controllers out there today.

Hard no on extending legacy SR-IOV API.
