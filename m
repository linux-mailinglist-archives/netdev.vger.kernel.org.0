Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36FFF15AF0E
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 18:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727429AbgBLRu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 12:50:57 -0500
Received: from mail-pl1-f170.google.com ([209.85.214.170]:33271 "EHLO
        mail-pl1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727231AbgBLRu5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 12:50:57 -0500
Received: by mail-pl1-f170.google.com with SMTP id ay11so1243535plb.0;
        Wed, 12 Feb 2020 09:50:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=WlfizKyJLlE4PPRpEBnAfQhblO6ccbV8l8FfcsZgVuU=;
        b=OMmy+8/yQYIE8kudw/ta1hRvXKj2eHxdbIRVeh0uciEHHqZTK7f79gQzG4g/v+PUad
         qZbe4/lE+9UWRqikkzt4QllvZHk8Q4Um325o4EG594R+4NABr7QdAJldUWojSlxtQoS3
         CRMpfZT6+VvB3LeFASwqPmc+VmhSsrndfqtvh22flVRJ96k3zpW1cK67ZE5q0Km015tX
         6YDjJ8UbR6kC/SMMwVvQSIT74XL2U5wv6iUV079C6JvjrFklRok1/nC+RRG+QGBAlJZ/
         2gj2Jdc3WsT6ZvtFlY3eHuYTMPv6ox1hbqZTRLQ6kFjMJP5OxYc1h7VBC6wWGM9QC3Tj
         5CTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=WlfizKyJLlE4PPRpEBnAfQhblO6ccbV8l8FfcsZgVuU=;
        b=dbZAmeDo8fCbh+2XJR+7YV+BkNnxMXTXPDGlqWUZfi5l7NJ9fekX0EDvjk/mwplizj
         8JM1LPRSARB8JCjvqQv1wQYDJY/CuSMNxad7Tr9GrU2JpdutpuUvPVk/cYrVxzf5DLeW
         jR3yg6zeSrE1F5rnb3lFOcKYUfwCPs94UubSUqtEQhOHIsHKlzgAJS2EXvOTCtFLz4oK
         gAHsBN4dKHXRGPBCQkQlgmRyoBT0xpZHtBolkPGvomVn90vmHJcAk7vqaXkdC6YEKVms
         V9RKIDTNZRMLo2HbYCMSdlXjHUY04GnQ4dcb3hHcUCVqm3RZdWQWJyRh/Ca3Rtl0raLx
         GtUQ==
X-Gm-Message-State: APjAAAXp3YwPuFfiN8kDj9GGfVJRodrqUnY9W/r0mNK8TwFBbiJBvviR
        2XDdeP5O4nz4FVlmxSw9+/+2VJlX
X-Google-Smtp-Source: APXvYqylxQAkr6l5pubQoJJDDtrgm6cLwOt+feOvg6PlruY4p00p9hlEEWhTd87WJUgAZkVJRUhZIg==
X-Received: by 2002:a17:90a:858a:: with SMTP id m10mr198932pjn.117.1581529856264;
        Wed, 12 Feb 2020 09:50:56 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id e4sm1067264pgg.94.2020.02.12.09.50.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2020 09:50:55 -0800 (PST)
To:     Michael Kerrisk <mtk.manpages@gmail.com>,
        netdev <netdev@vger.kernel.org>, linux-man@vger.kernel.org
From:   Eric Dumazet <eric.dumazet@gmail.com>
Subject: connect() man page
Message-ID: <f8517600-620b-1604-5f30-0f0698f5e33c@gmail.com>
Date:   Wed, 12 Feb 2020 09:50:53 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael

connect() man page seems obsolete or confusing :

       Generally,  connection-based  protocol  sockets may successfully connect()
       only once; connectionless protocol  sockets  may  use  connect()  multiple
       times  to  change  their association.  Connectionless sockets may dissolve
       the association by connecting to an address with the sa_family  member  of
       sockaddr set to AF_UNSPEC (supported on Linux since kernel 2.2).


1) At least TCP has supported AF_UNSPEC thing forever.

2) By definition connectionless sockets do not have an association,
   why would they call connect(AF_UNSPEC) to remove a connection which does not exist ...

Maybe we should rewrite this paragraph to match reality, since this causes confusion.


       Some protocol sockets may successfully connect() only once.
       Some protocol sockets may use connect() multiple times  to  change  their association.
       Some protocol sockets may dissolve the association by connecting to an address with
       the sa_family member of sockaddr set to AF_UNSPEC (supported on Linux since kernel 2.2).

Thanks.

