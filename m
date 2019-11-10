Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33CABF67F6
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 09:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbfKJIMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 03:12:55 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39814 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726582AbfKJIMz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 03:12:55 -0500
Received: by mail-wm1-f66.google.com with SMTP id t26so10230034wmi.4
        for <netdev@vger.kernel.org>; Sun, 10 Nov 2019 00:12:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wXZvkXnOuHMab3MFES6paENtqxXj9WAxeIR3xsx4Ejw=;
        b=chv7b36NP3BukPc8ynduuSAiyhF63q+M+raYQsAzxFmykPh3wGI3zslrYYle3l8fcm
         hbsmfIjQVpLh811Yzm3UmNDgove3WfFAEdqRC19MjaQ6Uy05jc2/jg2AmNvFJmtIXTXZ
         /AzB6xvWV4OzAmz+8viwR1L9HOlQs2f6LmZp8PJGZQDz+KgEvKsvfSheS1or6lPS0wzL
         88VoNZy9kXX4WwxdPsSOL4aZTQU3K5975H3YuH50oGMSXEJudUcL0valkHjVDY5cd56v
         ADZu42jVGZ4wFLAlluDgbKWt540JdRT4sfLOgoOZRFMrynBAq7QWLi3y4VJFDnPpYuaJ
         n8Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wXZvkXnOuHMab3MFES6paENtqxXj9WAxeIR3xsx4Ejw=;
        b=MY7xuSD/DkgykThghvU3jN1jJx+miAtkk2UGwetwyFeDqzTI73KGffrNilfDBkzhqk
         rhuPmnp16t5RVGP0dKcy16h3z7Hl0BQPAbFKVeAktOkeQ2Z6Xa7spti2EQn+8Tu8HdRs
         fF6jLUyg5/wMSHALxrH1Gfql/liVUGsXZiCcpMHTU9QI86njuVGdXkwWIogERc3LxOOX
         wcogZKWxyHYUV5v+hHNFMK7VOehIJs6ilvtjkZqDmVn4mxYjh4pncT21GT1kkqnbnT6E
         b6ue0JNlqw1X3w6u/62Eb4DnIVtd81crD3RWbcsj7hJFhM+PcFu5idn6XedZW1JN2A4k
         NQ1w==
X-Gm-Message-State: APjAAAVkxOmku/1ccxu7WGG/SOFo5U72ApgftzItIFxuvxb2BJDIyN9s
        /5mEhtR/J/yihK5UAMnAFOG+rA==
X-Google-Smtp-Source: APXvYqwmAZLKR9WBD2EdMSJkRdntq2AwKCrQuvLUDoBa/o4EVn7ZtrHo3R3Q81WyPA6+9Xoq8ppX4A==
X-Received: by 2002:a1c:6542:: with SMTP id z63mr15846378wmb.29.1573373573412;
        Sun, 10 Nov 2019 00:12:53 -0800 (PST)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id x205sm18624278wmb.5.2019.11.10.00.12.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Nov 2019 00:12:52 -0800 (PST)
Date:   Sun, 10 Nov 2019 09:12:51 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Parav Pandit <parav@mellanox.com>
Cc:     Yuval Avnery <yuvalav@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "shuah@kernel.org" <shuah@kernel.org>,
        Daniel Jurgens <danielj@mellanox.com>,
        "andrew.gospodarek@broadcom.com" <andrew.gospodarek@broadcom.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>
Subject: Re: [PATCH net-next v2 04/10] devlink: Support subdev HW address get
Message-ID: <20191110081251.GA2185@nanopsycho>
References: <1573229926-30040-1-git-send-email-yuvalav@mellanox.com>
 <1573229926-30040-5-git-send-email-yuvalav@mellanox.com>
 <AM0PR05MB48663DAB2C9B5359DB15BB89D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <AM6PR05MB5142FEFE41F0B06B7E61FEC5C57A0@AM6PR05MB5142.eurprd05.prod.outlook.com>
 <AM0PR05MB48669E4E79976591D8728D0AD17A0@AM0PR05MB4866.eurprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR05MB48669E4E79976591D8728D0AD17A0@AM0PR05MB4866.eurprd05.prod.outlook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Nov 09, 2019 at 07:13:30PM CET, parav@mellanox.com wrote:
>
>
>> From: Yuval Avnery <yuvalav@mellanox.com>
>> > > From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org>
>> > > Avnery <yuvalav@mellanox.com>
>> > > Subject: [PATCH net-next v2 04/10] devlink: Support subdev HW
>> > > address get
>> > >
>> > > Allow privileged user to get the HW address of a subdev.
>> > >
>> > > Example:
>> > >
>> > > $ devlink subdev show pci/0000:03:00.0/1
>> > > pci/0000:03:00.0/1: flavour pcivf pf 0 vf 0 port_index 1 hw_addr
>> > > 00:23:35:af:35:34
>> > >
>> > > $ devlink subdev show pci/0000:03:00.0/1 -pj {
>> > >     "subdev": {
>> > >         "pci/0000:03:00.0/1": {
>> > >             "flavour": "pcivf",
>> > >             "pf": 0,
>> > >             "vf": 0,
>> > >             "port_index": 1,
>> > >             "hw_addr": "00:23:35:af:35:34"
>> > I prefer this to be 'address' to match to 'ip link set address LLADDR'.
>> > That will make it consistent with rest of the iproute2/ip tool.
>> > So that users don't have to remember one mor keyword for the 'address'.
>> I think hw_addr is more accurate, and consistency doesn't exist here anyway.
>> We already have "ip link set vf set mac"
>> Address is not specific enough and can also mean IP address, while hw_addr
>> covers both ETH and IB
>Ok.
>
>Jiri,
>Do you want to wait to conclude the SF discussion, as we are discussing subdev there in confused state currently?

I belive that subdev is parallel to the discussion about SFs.
