Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84CAC181E68
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 17:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730406AbgCKQyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 12:54:09 -0400
Received: from mail-pl1-f177.google.com ([209.85.214.177]:37944 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729584AbgCKQyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 12:54:09 -0400
Received: by mail-pl1-f177.google.com with SMTP id w3so1366066plz.5
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 09:54:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=reply-to:to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=Db1MOk0psvgUimQ474KGdQlzYUKvJro1MKKIH+YlDug=;
        b=GuWerCJFGx7PQQX1jBUUXMX5u90Obty/Qe3Q87DnuYfNRlQGqmqmpqI+JjHx4ateXQ
         s30enhYnfkWmQWfRqwE3zKai0CYwQN1QX5E72emeex1HZfWAoo1/uLIOGb8rHlz6hC1J
         mvLbAelcighw6PZyiE1Grtczcf/mWdev2HrKVBXxBffGvJT+/4Lq9Q7VDUp86TrrQZaS
         76cRmb6Fkf6oxste+5g/waRJSPh8vKILf70KHx5vmwYc09nUZ17O9pQ6gChWVnIqAjS4
         v7gxOPVhXeOrt7ccx+o2pU7PFsaTOjGXdCABpxbk7ijRBEdhH2TEcQ7TaeSlhT3cAinV
         EoHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:to:from:subject:message-id:date
         :user-agent:mime-version:content-language:content-transfer-encoding;
        bh=Db1MOk0psvgUimQ474KGdQlzYUKvJro1MKKIH+YlDug=;
        b=Z9sYz1mPNEc1RamPGVnmdQzh2okYym06Zlct39w5zU4hPAfX3ZcrFlRl9QcOGYbtNd
         G+vb6V0FjHJ7+43Va1xsmUkl8BG2phJ7wXajfqNsoDyMff/nIxlR04wd5EvYiWBFuBKj
         gvUJxqlQrIR8Vc9PIdNDjjW+f57/aZiZ/uA4UP3m4bLKzk2CyHfLRbxrnXr6mAyrSCXk
         w5R+oSJdoLpMFoM3wtQqT1zCxubom+z7L/KjLp6O4PSwZJ7GOQedZDne+b+gmCtGu9bV
         TgvLkMvrqkWBTUVJ88LXJcZBv5+aXrQ+spcTXI4hi4iv4FQ+/HM5rp4BMPOfUEBhJDwO
         87kg==
X-Gm-Message-State: ANhLgQ3mikeYolGruSJUhFGkZ866mcJVv3fdgoGSrlStKpWuePFXUe4Z
        omj2lzaMAfObhzvSegE/CWEEt24d
X-Google-Smtp-Source: ADFU+vu+klXw3nFP89rG0gi4i8ilDZAg4Oe9cLSx2g1jn5hv465/7j451ABB17Bl4MXP7rJeopTRsg==
X-Received: by 2002:a17:90b:3645:: with SMTP id nh5mr4443016pjb.150.1583945647656;
        Wed, 11 Mar 2020 09:54:07 -0700 (PDT)
Received: from mua.localhost (99-7-172-215.lightspeed.snmtca.sbcglobal.net. [99.7.172.215])
        by smtp.gmail.com with ESMTPSA id y125sm1161498pfy.195.2020.03.11.09.54.07
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Mar 2020 09:54:07 -0700 (PDT)
Reply-To: pgnet.dev@gmail.com
To:     netdev@vger.kernel.org
From:   PGNet Dev <pgnet.dev@gmail.com>
Subject: iproute -> "Error: ipv4: FIB table does not exist."; unresolved,
 regression, or new issue?
Message-ID: <61d6802a-083a-82db-9a16-46728366bbf0@gmail.com>
Date:   Wed, 11 Mar 2020 09:54:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

with

	rpm -qa iproute*
		iproute2-5.5.0-197.8.x86_64

	uname -rm
		5.5.8-25.g1e5a090-default x86_64

on exec

	ip route show table default
		Error: ipv4: FIB table does not exist.
		Dump terminated

last i've managed to find on this is in an exchange between dsahern@ & emersonbernier@

	Re: [BUG][iproute2][5.0] ip route show table default: "Error: ipv4: FIB table does not exist."
	 https://www.spinics.net/lists/netdev/msg569682.html

then I lost the thread ...

had this issue moved elsewhere, and been dealt with already -- & this is a regression?

or, just still a pending issue?
