Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8C12152BB
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 08:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728084AbgGFGey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 02:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbgGFGex (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 02:34:53 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 477B1C061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 23:34:53 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id f7so36508349wrw.1
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 23:34:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vusR7Udle/joV+Wqxbtpki1vDkcBy0QYRYxJjsQCBSI=;
        b=uVtjsCaovPQrbprwgnv/oI4J5wS5Kj6k8u32nfjo2mBUnVYzpaJVE4KJ0jQuPkbtfG
         2GADPzt4OhdcHmsL8hTDOF+SCw2uH4Rm6DovzyaoWifZNQ3wUzkM81QY+cLMYrtvFGuu
         Gha63GLvHwzgm2ZUwwYRxc7vYDZng37/aVd4qsb7ZzliG0Q0NCcFRJY26I/1XvX92iPt
         5i9Q/Fzto8CBDbmgyCCy56pVZK7azqv86TUg/OLBu+L7PoLL37e0ZY8tvxwFFXI+3Fdp
         IKljJe+Xhv7iIG4MEoM86AwICWOzeS8cvlpV670EOSdjXKCKSoxyLRT5hIO6yS0tBIMl
         nbpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vusR7Udle/joV+Wqxbtpki1vDkcBy0QYRYxJjsQCBSI=;
        b=efTGBIyGPw8ze7Y0rxMcM7EfNwDYRVS1IgHEnygEyb5Qfzlp8G/lx8o4njlG/U13NR
         F7GU1boOIB6Je7PmnikcikfGQgMKMXb2vOQwRa96MAjcUZjUna0eKguKJKnYA0owAURC
         FvBjaVkuf/HLWh1JFeCbmw3SfnsG5ya84+hCLnjdyJCXgK00R972FwLcHc9jaaDqABi1
         W6UIEgwyPn1c2DvATB2KXijNUD8v1iLZVaLz9B6LyTr8mxwJPpYBffJEGWYvuGaa3Uso
         Uk6TbSLwyszgRavAM5JNM/Pha74Xdwug6+3GS7BTv0v2Q4qhDHbYcBe0V5m33wBopnfY
         UsZg==
X-Gm-Message-State: AOAM530EtP+XaETXQ3ylguigD2gs9OQgfYtZOLt2XENk4e+VAlYqCt86
        fB089R4GmX3P5WYdmFncyvxZMg==
X-Google-Smtp-Source: ABdhPJxTD7P+Ta0iCzUkBvd0HNtY51RE2SFRWQjlVXYuo5lwWIPa57BZI4RITYUw+Y6QA4CujuKEJA==
X-Received: by 2002:adf:ef89:: with SMTP id d9mr50015461wro.124.1594017291919;
        Sun, 05 Jul 2020 23:34:51 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id q7sm11287170wra.56.2020.07.05.23.34.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jul 2020 23:34:51 -0700 (PDT)
Date:   Mon, 6 Jul 2020 08:34:50 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        netdev@vger.kernel.org, dsahern@gmail.com, davem@davemloft.net,
        jiri@mellanox.com, kuba@kernel.org, michael.chan@broadcom.com
Subject: Re: [PATCH v2 iproute2-next] devlink: Add board.serial_number to
 info subcommand.
Message-ID: <20200706063450.GA2251@nanopsycho.orion>
References: <1593416584-24145-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <20200705110301.20baf5c2@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200705110301.20baf5c2@hermes.lan>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Jul 05, 2020 at 08:03:01PM CEST, stephen@networkplumber.org wrote:
>On Mon, 29 Jun 2020 13:13:04 +0530
>Vasundhara Volam <vasundhara-v.volam@broadcom.com> wrote:
>
>> Add support for reading board serial_number to devlink info
>> subcommand. Example:
>> 
>> $ devlink dev info pci/0000:af:00.0 -jp
>> {
>>     "info": {
>>         "pci/0000:af:00.0": {
>>             "driver": "bnxt_en",
>>             "serial_number": "00-10-18-FF-FE-AD-1A-00",
>>             "board.serial_number": "433551F+172300000",
>>             "versions": {
>>                 "fixed": {
>>                     "board.id": "7339763 Rev 0.",
>>                     "asic.id": "16D7",
>>                     "asic.rev": "1"
>>                 },
>>                 "running": {
>>                     "fw": "216.1.216.0",
>>                     "fw.psid": "0.0.0",
>>                     "fw.mgmt": "216.1.192.0",
>>                     "fw.mgmt.api": "1.10.1",
>>                     "fw.ncsi": "0.0.0.0",
>>                     "fw.roce": "216.1.16.0"
>>                 }
>>             }
>>         }
>>     }
>> }
>
>Although this is valid JSON, many JSON style guides do not allow
>for periods in property names. This is done so libraries can use
>dot notation to reference objects.
>
>Also the encoding of PCI is problematic

Well, besides board.serial_number, this is what we have right now...

>
>
