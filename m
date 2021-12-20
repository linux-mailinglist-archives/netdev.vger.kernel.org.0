Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7EBB47B0AA
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 16:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237287AbhLTPvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 10:51:13 -0500
Received: from s-terra.s-terra.com ([213.5.74.59]:43240 "EHLO
        s-terra.s-terra.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237009AbhLTPvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 10:51:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=s-terra.ru; s=mail;
        t=1640015470; bh=d7yN5PIhbYqpDtPF3dHjEH3ucdSFdktzO9HLrdPhJjs=;
        h=To:From:Subject:Date:From;
        b=RVBr0zbaYJqEf8b2YkPY/8+9cBtbxLsB+RrH/ogxF+wH7P40x8l52yRKijhbd/dOx
         RrSi62hMEJVsEH5Ktl0K16KA+9q9jgEIrUpBEY3RWuwM3zfbaX6gWJ65WKVZSauums
         Ej89XeqG3NeIVlbrgDlunhm4ZiGUqWkwW/lmAmUM=
To:     <netdev@vger.kernel.org>
From:   =?UTF-8?B?0JzRg9GA0LDQstGM0LXQsiDQkNC70LXQutGB0LDQvdC00YA=?= 
        <amuravyev@s-terra.ru>
Subject: failed to set GRE remote IP address after interface was created
Message-ID: <389196c8-1223-f996-3309-653b56fa4386@s-terra.ru>
Date:   Mon, 20 Dec 2021 18:51:09 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: EMX.sterracsp.s-terra.com (10.0.0.10) To
 EMX.sterracsp.s-terra.com (10.0.0.10)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is impossible to change a remote IP address for a GRE interface if it 
was initially created without specifying a remote address.

E.g. if the interface was created by command "ip tunnel add gre1 mode 
gre key 123", it is impossible to specify a remote IP address:

"ip tunnel change gre1 remote 1.1.1.1" gives invalid argument error.

I was able to reproduce the behavior in modern Debian and Ubuntu systems.

Is it impossible to change "point-to-point" GRE interface to 
"point-to-multipoint" and vice versa? I just was unable to find this bug 
description/ticket.


Alexander Muravev


