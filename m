Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB2A15B86E
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 11:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727606AbfGAJzB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 1 Jul 2019 05:55:01 -0400
Received: from mail5.windriver.com ([192.103.53.11]:53660 "EHLO mail5.wrs.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727477AbfGAJzB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jul 2019 05:55:01 -0400
Received: from ALA-HCA.corp.ad.wrs.com (ala-hca.corp.ad.wrs.com [147.11.189.40])
        by mail5.wrs.com (8.15.2/8.15.2) with ESMTPS id x619rqxD000538
        (version=TLSv1 cipher=AES128-SHA bits=128 verify=FAIL);
        Mon, 1 Jul 2019 02:54:17 -0700
Received: from ALA-MBD.corp.ad.wrs.com ([169.254.3.194]) by
 ALA-HCA.corp.ad.wrs.com ([147.11.189.40]) with mapi id 14.03.0439.000; Mon, 1
 Jul 2019 02:53:59 -0700
From:   "Hallsmark, Per" <Per.Hallsmark@windriver.com>
To:     Alexey Dobriyan <adobriyan@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] let proc net directory inodes reflect to active net
 namespace
Thread-Topic: [PATCH] let proc net directory inodes reflect to active net
 namespace
Thread-Index: AQHVK0C2SQYwxDnNd0ORdMMwE+Y4tqazHFaAgAJywgI=
Date:   Mon, 1 Jul 2019 09:53:58 +0000
Message-ID: <B7B4BB465792624BAF51F33077E99065DC5D8DC3@ALA-MBD.corp.ad.wrs.com>
References: <B7B4BB465792624BAF51F33077E99065DC5D7225@ALA-MBD.corp.ad.wrs.com>,<20190629132959.GA9370@avx2>
In-Reply-To: <20190629132959.GA9370@avx2>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [128.224.93.131]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Indeed it does! :-)

I'll make a new version.

________________________________________
From: Alexey Dobriyan [adobriyan@gmail.com]
Sent: Saturday, June 29, 2019 15:29
To: Hallsmark, Per
Cc: David S. Miller; linux-kernel@vger.kernel.org; netdev@vger.kernel.org
Subject: Re: [PATCH] let proc net directory inodes reflect to active net namespace

On Tue, Jun 25, 2019 at 10:36:06AM +0000, Hallsmark, Per wrote:
> +struct proc_dir_entry *proc_net_mkdir(struct net *net, const char *name,
> +                                   struct proc_dir_entry *parent)
> +{
> +     struct proc_dir_entry *pde;
> +
> +     pde = proc_mkdir_data(name, 0, parent, net);
> +     pde->proc_dops = &proc_net_dentry_ops;
> +
> +     return pde;
> +}

This requires NULL check at least.
