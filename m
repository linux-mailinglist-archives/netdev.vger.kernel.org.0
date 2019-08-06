Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDFE583845
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 19:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730268AbfHFRze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 13:55:34 -0400
Received: from mail-pf1-f182.google.com ([209.85.210.182]:45500 "EHLO
        mail-pf1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726713AbfHFRze (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 13:55:34 -0400
Received: by mail-pf1-f182.google.com with SMTP id r1so41903834pfq.12
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 10:55:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DC/eATgO+yTMJ9TQdGtekHMLvkJCk3IHb9ZpH6I6iro=;
        b=Wswq5sOp3zV/MSlVxDcZ3rWQZ8rVAFDu/Y/8d5x7otRxZ0be9LDkPvNMQpsrvowhCZ
         VQdAwCth1MvrA0Gvq+4WphXrV6jop0Cf2mWb69lcv7xBGdVMR983Sq63dTXVDuh26NaL
         yCFxd0ivh++B7AJ6EghlDENgzauake5lkGDCO2469DS/NzxcbXFnf8vhdIZsSb2opDgP
         t7QjTBjp6rlMb4tXrezIhAuzT8Y5cxsOLbQ7FFEwUC0o2Ety1TPpbIBnK6dh+xjWAiWo
         I5OGPMLoqXNewNPshKXfknb7KDXNCeO+DcVR5+Hb/GZzMctNA4u6uSyG/5OgFXBTxoq4
         8MWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DC/eATgO+yTMJ9TQdGtekHMLvkJCk3IHb9ZpH6I6iro=;
        b=XFOktR9YSAVvaOQg6DRsCXg4Jhfis7nkwzy6tsxnPI4FSC8tjaaBFqblVj8232EYEV
         HLRprvvYfePS4KFqtPmi5IbbVYVkbh4m3nAs9Lt1oFY6UxmjGSYotus+MSQLTRVP6Hyr
         VvlZVarcCwy/pfMqMsAUeSQG1LPa1xH3HFjBldBlMyGbhd9jRpW7WLJHqPX5XBL8W8Rq
         ruIgcwJbjIqwnWNYCrzNGgkMwUIq4gIJx5uFu9rkn3cRo8wK4E8LFDyfhjh8thf4Qove
         IOw8cpDFYPsf3HxSbvN88yzXrabR0w+4diexJ3eFlUgcAXhHNLWOztDVV0OCOBkzp/NT
         zjrQ==
X-Gm-Message-State: APjAAAW3kIhUMPV4sucC4SSi3q1VAlaipKZ20VhoU72L5n6t4aUeACGG
        QhCqCZyUZUVfxKKbY7qA76E=
X-Google-Smtp-Source: APXvYqyWfYRHpbqadRWWVCYhPTASJE8KPIlRJnNSRBhwzPLsZTinEStR1FxQLPBKaNYLJ6KNE1Acpw==
X-Received: by 2002:a65:6096:: with SMTP id t22mr2863521pgu.204.1565114133363;
        Tue, 06 Aug 2019 10:55:33 -0700 (PDT)
Received: from [172.27.227.131] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id i14sm136558353pfk.0.2019.08.06.10.55.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Aug 2019 10:55:32 -0700 (PDT)
Subject: Re: [patch net-next v2 1/3] net: devlink: allow to change namespaces
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, davem@davemloft.net,
        sthemmin@microsoft.com, mlxsw@mellanox.com
References: <087f584d-06c5-f4b9-722b-ccb72ce0e5de@gmail.com>
 <89dc6908-68b8-5b0d-0ef7-1eaf1e4e886b@gmail.com>
 <20190802074838.GC2203@nanopsycho>
 <6f05d200-49d4-4eb1-cd69-bd88cf8b0167@gmail.com>
 <20190805055422.GA2349@nanopsycho.orion>
 <796ba97c-9915-9a44-e933-4a7e22aaef2e@gmail.com>
 <20190805144927.GD2349@nanopsycho.orion>
 <566cdf6c-dafc-fb3e-bd94-b75eba3488b5@gmail.com>
 <20190805152019.GE2349@nanopsycho.orion>
 <7200bdbb-2a02-92c6-0251-1c59b159dde7@gmail.com>
 <20190806175323.GB2332@nanopsycho.orion>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <fc6a7342-246c-2fe1-a7d1-c7be5bd0a3a3@gmail.com>
Date:   Tue, 6 Aug 2019 11:55:30 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190806175323.GB2332@nanopsycho.orion>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/6/19 11:53 AM, Jiri Pirko wrote:
> Let's figure out the devlink-controlling-kernel-resources thread first.
> What you describe here is exactly that.

as I mentioned on the phone, any outcome of that thread will be in 5.4
at best. Meanwhile this breakage in 5.2 and 5.3 needs to be fixed.
