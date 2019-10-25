Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E74D0E55A3
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 23:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725977AbfJYVKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 17:10:11 -0400
Received: from mail-io1-f46.google.com ([209.85.166.46]:44639 "EHLO
        mail-io1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbfJYVKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 17:10:11 -0400
Received: by mail-io1-f46.google.com with SMTP id w12so3934373iol.11
        for <netdev@vger.kernel.org>; Fri, 25 Oct 2019 14:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qgK2ccsF1mioD5325j3mUfVv880Lhb3tGGmfsqSdaVo=;
        b=nYobvfY6+amBbT/fgyOv9GSHLPFiLNsVn5sCb2gek9r0HftMKnFlcML3v1Jz0WXUef
         AEjo+u1CUe6F665iF7fpIUBPm3f16p/aT5Tul427SjrjWG9ahjTABpp6nbZbR1bOt1Lm
         4JB78CN9WzTJKYpEw3XM9Fy83QvS7lDpEpqSX1Zt6ZnO5gtIvStfSWqpWk8Jrr9+r5pD
         8Ur6yogXHULIDw3DI4ygftM/J4No2Go11a/Fq8VSeyoiwCAcxBjprH0Ka82kz418VZz4
         Tr+2RVi+5qAe2bI1bLZjAUGNSIWgnt+CPXgAe5yYuKQHfewpEXwa+L/0+VmVz7hD454f
         tFbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qgK2ccsF1mioD5325j3mUfVv880Lhb3tGGmfsqSdaVo=;
        b=CF923sodLR2fI8fYWzSvq8iJO44QG4hdU5ROzrE+HF4zGRTRNa4iMgon4P0uoIjxD7
         K7UZBKfLuhCo7jP2n2Rn076ddbxPjDfJ4/4l+NEnLiefL65Pyj9jgQApO36XDJ6lUXyK
         SPccaFDmlTEGmKu03nET9nI3Hfgf93FQQ/MKJnKOzhskuW6FoSrwiheKNs15ZxKofjPL
         AhCi3ov2KuoA1vEPg9gFhfV0vmnxHgmyPBGJ5cLvg5qMDiqx0Lc2n4Ss67so//qbrbQV
         VIt4H1ke8G9yBFFi+zyZFnrYMO7iDO9UFMkp0RhWh+qNdGIfXc3b56H8gthkNSoXecfG
         PsIg==
X-Gm-Message-State: APjAAAVRp1HWknln5MpZt8VnzWP2el2x2RbbENritudkflp+k2mnQQxx
        SxkFmsUje4cqixJmg/fNHANNuw==
X-Google-Smtp-Source: APXvYqyvnm3X6BiF9D+vNZGqO3WVCR5jXrst3yXk+ZZC2E96wcljSrEg1OtEe3YHIvaVWxD9LV3NkA==
X-Received: by 2002:a02:c544:: with SMTP id g4mr6174710jaj.79.1572037808654;
        Fri, 25 Oct 2019 14:10:08 -0700 (PDT)
Received: from [10.0.0.194] ([64.26.149.125])
        by smtp.googlemail.com with ESMTPSA id e4sm489021ilg.33.2019.10.25.14.10.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Oct 2019 14:10:08 -0700 (PDT)
Subject: Re: [PATCH net-next 00/13] Control action percpu counters allocation
 by netlink flag
From:   Jamal Hadi Salim <jhs@mojatatu.com>
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mleitner@redhat.com" <mleitner@redhat.com>,
        "dcaratti@redhat.com" <dcaratti@redhat.com>,
        Eric Dumazet <edumazet@google.com>
References: <20191022141804.27639-1-vladbu@mellanox.com>
 <78ec25e4-dea9-4f70-4196-b93fbc87208d@mojatatu.com>
 <vbf7e4vy5nq.fsf@mellanox.com>
 <dc00c7a4-a3a2-cf12-66e1-49ce41842181@mojatatu.com>
 <20191024073557.GB2233@nanopsycho.orion> <vbfwocuupyz.fsf@mellanox.com>
 <90c329f6-f2c6-240f-f9c1-70153edd639f@mojatatu.com>
 <vbftv7wuciu.fsf@mellanox.com>
 <fab8fd1a-319c-0e9a-935d-a26c535acc47@mojatatu.com>
 <48a75bf9-d496-b265-bdb7-025dd2e5f9f9@mojatatu.com>
 <vbfsgngua3p.fsf@mellanox.com>
 <7488b589-4e34-d94e-e8e1-aa8ab773891e@mojatatu.com>
 <43d4c598-88eb-27b3-a4bd-c777143acf89@mojatatu.com>
 <vbfpniku7pr.fsf@mellanox.com>
 <07a6ceec-3a87-44cb-f92d-6a6d9d9bef81@mojatatu.com>
 <vbfmudou5qp.fsf@mellanox.com>
 <894e7d98-83b0-2eaf-000e-0df379e2d1f4@mojatatu.com>
 <d2ec62c3-afab-8a55-9329-555fc3ff23f0@mojatatu.com>
Message-ID: <710bf705-6a58-c158-4fdc-9158dfa34ed3@mojatatu.com>
Date:   Fri, 25 Oct 2019 17:10:06 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <d2ec62c3-afab-8a55-9329-555fc3ff23f0@mojatatu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-10-25 5:05 p.m., Jamal Hadi Salim wrote:
> +	if (!root_flags && tb[TCA_ACT_ROOT_FLAGS]) {
> +		rf = nla_get_bitfield32(tb[TCA_ACT_ROOT_FLAGS]);
> +		root_flags = &rf;
> +	}



!root_flags check doesnt look right.
Hopefully it makes more sense now....

cheers,
jamal
