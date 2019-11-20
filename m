Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C558103E12
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 16:15:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728115AbfKTPPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 10:15:31 -0500
Received: from mail-qv1-f65.google.com ([209.85.219.65]:44650 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726771AbfKTPPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 10:15:31 -0500
Received: by mail-qv1-f65.google.com with SMTP id d3so14759qvs.11
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 07:15:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=bbDGyfqdwLL6cUlQDJJHRqAuoRMp5k8JN9fNd2psBnk=;
        b=LVmaHOzMHD7+sCaojIObjUuACpc0AEOQEtwy/NyMXZV8uUd91G/tPn+AkOeKM1QJnX
         gtWYmhEqFQMzcYweC0NxGP23MaXMVtMP2B/DsLU6MU/NSCtEBhWRNA/NtTgVvPL96lUl
         eBpacWJ8V1rvY13HqKufQsxR5Nmaonl2Z5AjG3+jGMiMsTv8xK8TYmP9+WAkGwy9i5/u
         aMzTKez3JwjJ55I6jEtzVcP8LtHBJsN03a2BafOsDxnkQHbLGMDbwetUuWPqHhRTHBqb
         x43Oo5V3TvDVGzTeOWPO3JHuUGsQEX3Xbcp1v2u1uC0wbMUktQWOuExVgfcaGtBreRwK
         r7WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=bbDGyfqdwLL6cUlQDJJHRqAuoRMp5k8JN9fNd2psBnk=;
        b=D710V738zUr/T/qGvW2vakFW7c2922fCG2LKWZpd3gpnxBdrqBnP26D2LjiE19AviN
         jnn89rWrCjJlVDylGPxQG3Izdcx3cUzIbd312NEYPCyTPMxvFGpsNxdkZ52jiZgqpW3G
         8/enxuoRoI61spW8b9V//ozm9zKfQJLfuoFPMxshqmIm9EA/3pRhsh2n9OK+OSa/y1Bt
         tjjqCnCXifBU/7DwcCtbtg1B00Sc1i94aScCBMI1CQFPsoM1xPOGuMqBmx3IGKz7LWpB
         A+ZMuRRUkxtT99ul9rmpNTilkEBZMeEcYywGqBHx/gaqQ6OY3NZjxjPxk47k9Y/OSM/n
         IzUw==
X-Gm-Message-State: APjAAAWYbw1X1e3kZnW7JsZERDSHxI9KXxZSteFpjNv6wmE9JG4MByee
        d06DxFDmEbB/oGtHbIevd2jAkg==
X-Google-Smtp-Source: APXvYqx3UpRhFMEIJSRHP+nPvcV1s75ql4QRx1lncb0vVjJ6uFXcvj/+TPNCitae7Y79d5BtYyCpJw==
X-Received: by 2002:a05:6214:22c:: with SMTP id j12mr2965582qvt.150.1574262930539;
        Wed, 20 Nov 2019 07:15:30 -0800 (PST)
Received: from sevai (69-196-152-194.dsl.teksavvy.com. [69.196.152.194])
        by smtp.gmail.com with ESMTPSA id x25sm11784509qki.63.2019.11.20.07.15.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Nov 2019 07:15:29 -0800 (PST)
From:   Roman Mashak <mrv@mojatatu.com>
To:     Petr Machata <petrm@mellanox.com>
Cc:     "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>
Subject: Re: [RFC PATCH 10/10] selftests: qdiscs: Add test coverage for ETS Qdisc
References: <cover.1574253236.git.petrm@mellanox.com>
        <4c364de6add3e615f1675ddb4d2911491a65bd8a.1574253236.git.petrm@mellanox.com>
Date:   Wed, 20 Nov 2019 10:15:28 -0500
In-Reply-To: <4c364de6add3e615f1675ddb4d2911491a65bd8a.1574253236.git.petrm@mellanox.com>
        (Petr Machata's message of "Wed, 20 Nov 2019 13:05:19 +0000")
Message-ID: <85h82ybmun.fsf@mojatatu.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Petr Machata <petrm@mellanox.com> writes:

> Add TDC coverage for the new ETS Qdisc.
>

It would be good to have tests for upper bound limits of qdisc
parameters.

> Signed-off-by: Petr Machata <petrm@mellanox.com>
> ---
>  .../tc-testing/tc-tests/qdiscs/ets.json       | 709 ++++++++++++++++++
>  1 file changed, 709 insertions(+)
>  create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/ets.json
>
> diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/ets.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/ets.json
> new file mode 100644
> index 000000000000..6619d6bceb49
> --- /dev/null
> +++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/ets.json
> @@ -0,0 +1,709 @@
> +[
> +    {
> +        "id": "e90e",
> +        "name": "Add ETS qdisc using bands",
> +        "category": [
> +            "qdisc",
> +            "ets"
> +        ],

[...]

