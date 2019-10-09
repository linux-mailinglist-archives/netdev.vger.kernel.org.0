Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEEF7D0749
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 08:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729575AbfJIGgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 02:36:10 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:44225 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726765AbfJIGgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 02:36:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570602968;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=DRp1swJmLGnIlAf7XMxEoZkdOJe88OuGnn8pzjWNfwY=;
        b=N8bQXPn4HettIkUNNDz5xBGXwt7UnT7OEJmLqYnh5tt0pDRRBbOILhIwucIC9yZGWELWEJ
        oNgQt5TgyuFLc9HAr+sbZfFUlFybgs0gbgTnysgGD5KvWsjbEUMNtrB5Y/2rrtCFgUOAyE
        r40LjompiqmFacQLtUwC/zkN5dLT0g4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148-QLOpiHn4Ns63sgWnf1HMRw-1; Wed, 09 Oct 2019 02:36:04 -0400
Received: by mail-wr1-f70.google.com with SMTP id c17so616243wro.18
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 23:36:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DRp1swJmLGnIlAf7XMxEoZkdOJe88OuGnn8pzjWNfwY=;
        b=QnOo2R1CrnutuK9tjOEJrvCJnKmndHAvrPgOM4g25KSTwLeMDoKs6aKNJNMGpFELD5
         NhHBNKtXxQpudoNz7cTsLRKXP/6eTJX8JpUoYezXmLyEo1/hU6OH7es6ATPNn0VSSBKo
         f2CdGCgdEVN7DM6TqCoq6LH+VUG5QibzcH4jTckWVAXZ6+E26Rc3qyX64T/wfSI2T/YL
         mm/OGdraxwUa2840LanYOYtUMauH6GIjQUuk18FW0/dn0fO3r1tgL2nXGSDQwHB67/9v
         SPdOoxPBSD50VtcxNRO7ShsmQAlMc7iaWJMHtcHvSkOSPNlYC5AbzNYL3Sn/qCnVxdA3
         zfJw==
X-Gm-Message-State: APjAAAXwCv6mEomeGz0CvQn3MRjaxh/bKEuCN67aOOxgIIlf4zpOVJ6G
        SFr5Ok2IyB6JLBQmDywFxwKvJUjSrJwqHG3qRZhMrnsdtr/L2VYlmSSik+vzsGxcljuz/X3Fjzw
        2zc0V5nSkWRjPGpnq
X-Received: by 2002:a5d:5610:: with SMTP id l16mr1515938wrv.143.1570602963414;
        Tue, 08 Oct 2019 23:36:03 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwIwCawDi6R5bC55JQUaG89aKMEczYrGrPl67xVSkSyIT2j1JE6iE4/baYaPJLh4Q90kl9l8Q==
X-Received: by 2002:a5d:5610:: with SMTP id l16mr1515916wrv.143.1570602963107;
        Tue, 08 Oct 2019 23:36:03 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:f4b0:55d4:57da:3527? ([2001:b07:6468:f312:f4b0:55d4:57da:3527])
        by smtp.gmail.com with ESMTPSA id m7sm993787wrv.40.2019.10.08.23.36.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Oct 2019 23:36:02 -0700 (PDT)
Subject: Re: [RFC PATCH v3 4/6] psci: Add hvc call service for ptp_kvm.
To:     "Jianyong Wu (Arm Technology China)" <Jianyong.Wu@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Suzuki Poulose <Suzuki.Poulose@arm.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Steve Capper <Steve.Capper@arm.com>,
        "Kaly Xin (Arm Technology China)" <Kaly.Xin@arm.com>,
        "Justin He (Arm Technology China)" <Justin.He@arm.com>,
        nd <nd@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
References: <20190918080716.64242-1-jianyong.wu@arm.com>
 <20190918080716.64242-5-jianyong.wu@arm.com>
 <83ed7fac-277f-a31e-af37-8ec134f39d26@redhat.com>
 <HE1PR0801MB1676F57B317AE85E3B934B32F48E0@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <629538ea-13fb-e666-8df6-8ad23f114755@redhat.com>
 <HE1PR0801MB167639E2F025998058A77F86F4890@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <ef6ab8bd-41ad-88f8-9cfd-dc749ca65310@redhat.com>
 <a1b554b8-4417-5305-3419-fe71a8c50842@kernel.org>
 <56a5b885-62c8-c4ef-e2f8-e945c0eb700e@redhat.com>
 <HE1PR0801MB1676115C248E6DF09F9DD5A6F4950@HE1PR0801MB1676.eurprd08.prod.outlook.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <1cc145ca-1af2-d46f-d530-0ae434005f0b@redhat.com>
Date:   Wed, 9 Oct 2019 08:36:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <HE1PR0801MB1676115C248E6DF09F9DD5A6F4950@HE1PR0801MB1676.eurprd08.prod.outlook.com>
Content-Language: en-US
X-MC-Unique: QLOpiHn4Ns63sgWnf1HMRw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/10/19 07:21, Jianyong Wu (Arm Technology China) wrote:
> As ptp_kvm clock has fixed to arm arch system counter in patch set
> v4, we need check if the current clocksource is system counter when
> return clock cycle in host, so a helper needed to return the current
> clocksource. Could I add this helper in next patch set?

You don't need a helper.  You need to return the ARM arch counter
clocksource in the struct system_counterval_t that you return.
get_device_system_crosststamp will then check that the clocksource
matches the active one.

Paolo

