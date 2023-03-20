Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBCDD6C2452
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 23:16:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbjCTWQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 18:16:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbjCTWQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 18:16:13 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F9BE17CC2
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 15:16:12 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id r29so11854523wra.13
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 15:16:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679350571;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H2UptfLwjKiEotTRfFpb5ttJ1VC+lt0QAQv00XO7FzU=;
        b=CkQwLMbhE+FUWa03xpfP4nOL9nUv+BwFRKZwwACod0aM7irzKRlYh17ogeF583L7o+
         6VI/06JxgkNSLT6T1cWWiHtXTj962PUEq/FQf4i8KlnUq6PtfrXvFfSyvFROGM4QFw72
         dThGeSv6ll97M4JivH0HcJZW9uNFRBQHKtVDfmPsDtzqBDhuOSdUD2AYijKuH6djLYfo
         LwII/DDsDgwe+rK+tN0Y69xBmrtsr/fO7w3hmxR1X70ZHT2t6sXBpycM+f0rkDMdLR1A
         v1O2wGQvIKrPncB2xePhTDIy1sXTI1I1juHZgyjyHb+G/rTSGuhhWRj9xU5LmERZPZQT
         H8FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679350571;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H2UptfLwjKiEotTRfFpb5ttJ1VC+lt0QAQv00XO7FzU=;
        b=1+mKF/Bmm9dCbmeuOCxjZ8FImKqdHkcnKLl+WoG8t29i/Vf0eRUVprp4K7OT5Tb4w/
         y4LD4+EiEfTAO2MHoXuVIurH7ohNrnmDTzX3OE6UjGyaAYsw6p6vaTnGcylUHlTillcS
         EPDNw346hbzqf6CwfQOAPK5zbvZaqgktp1d8URonbWUka+e0oU8FoAa3JYvy47ixO3+5
         EAe8JKUOav7k0jfSeuombudntRw9qY+RGA4m/e9VetY7nTOCHCuZdInOcyyiazjyiuQl
         6yfL2wnwI/TEugMRIxpXbTlPFTSkCT6kdTa5lpIy8sg6Mnfagb4nBPzyhSuK1HFpJVx/
         8mKQ==
X-Gm-Message-State: AO0yUKWlVHljEJqTorKc8U5y/IJxsUWhu2SvBMyTrwEe48D1EKI3Tvsh
        rDMj+RhFh1/JbdC5gRFYDa8=
X-Google-Smtp-Source: AK7set/gffFtTPHKC/G0zfopRP1us39GV+KIwWtflu4sQBhuE89KayWg2YiIdLY4gCe8C+Bgl00xQQ==
X-Received: by 2002:adf:e24d:0:b0:2c7:17a5:8687 with SMTP id bl13-20020adfe24d000000b002c717a58687mr708934wrb.0.1679350570899;
        Mon, 20 Mar 2023 15:16:10 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id p5-20020adfce05000000b002d64fcb362dsm4566460wrn.111.2023.03.20.15.16.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 15:16:10 -0700 (PDT)
Subject: Re: [PATCH net] tools: ynl: add the Python requirements.txt file
To:     "Michalik, Michal" <michal.michalik@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
References: <20230314160758.23719-1-michal.michalik@intel.com>
 <20230315214008.2536a1b4@kernel.org>
 <BN6PR11MB41772BEF5321C0ECEE4B0A2BE3809@BN6PR11MB4177.namprd11.prod.outlook.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <560bd227-e0a9-5c01-29d8-1b71dc42f155@gmail.com>
Date:   Mon, 20 Mar 2023 22:16:09 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <BN6PR11MB41772BEF5321C0ECEE4B0A2BE3809@BN6PR11MB4177.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/03/2023 19:03, Michalik, Michal wrote:
> From: Jakub Kicinski <kuba@kernel.org> 
>> Why the == signs? Do we care about the version of any of these?
> 
> I cannot (you probably also not) guarantee the consistency of the API of
> particular libraries.

Assuming the libraries are following best practice for their version
 numbering (e.g. semver), you should be able to use ~= ('compatible
 version' [1]).
For example, `jsonschema ~= 4.0` will allow any 4.x.y release, but
 not 5.0.0 since that could have breaking API changes.
I would recommend against pinning to a specific version of a
 dependency; this is a development tree, not a deployment script.

> No, you did not forget about anything (besides the PyYAML that you didn't
> mention above). There is more than you expect because `PyYAML` and
> `jsonschema` have their own dependencies.

Again I'd've thought it's better to let those packages declare their
 own dependencies and rely on pip to recursively resolve and install
 them.  Both on separation-of-concerns grounds and also in case a
 newer version of a package changes its dependencies.
(Probably in the past pinning all dependencies at the top level was
 needed to work around pip's lack of conflict resolution, but this
 was fixed in pip 20.3 [2].)

-ed

[1]: https://peps.python.org/pep-0440/#compatible-release
[2]: https://pip.pypa.io/en/latest/user_guide/#changes-to-the-pip-dependency-resolver-in-20-3-2020
