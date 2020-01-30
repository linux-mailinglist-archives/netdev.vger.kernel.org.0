Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A34EB14DC6D
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 15:06:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727405AbgA3OGA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 09:06:00 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:41026 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727241AbgA3OF7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jan 2020 09:05:59 -0500
Received: by mail-ed1-f66.google.com with SMTP id c26so3919369eds.8
        for <netdev@vger.kernel.org>; Thu, 30 Jan 2020 06:05:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=KLUUmwLfL0lJg5nXfpErbvGaGXJyUwIdXajuKEnP8mw=;
        b=nF69eL4lUe+FaC4daOF/6sydBjpN787oHOImlOKuFYw+q1Rk9VVKyNNsEsBNIW02WJ
         ftQF5AZ5l7Wnlpi0l6gFqPTmYbvVSNBpwFj+Wm/IDN06XTYKirC3PofAmvNfeiNQlMG8
         odRdTWUXm9/sHepA1i9wpDlX0kg3C1GweNP+joTXH8yY7SQ4fQwa0XsmpK+lrf+fkvJu
         N1xUKC7ORPmMoxr9qJWDTOUh6VWnAKOWVM8tUXcq1W/bg99qygiBzAqGMPYi4OfDLs7L
         omOqdfyupMJRa0Iku1kycdZXAI7sJVw03SEBnuP8sb4gsdThTOovSzisNgod55L+eLdH
         EJjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:in-reply-to:references
         :from:date:message-id:subject:to:content-transfer-encoding;
        bh=KLUUmwLfL0lJg5nXfpErbvGaGXJyUwIdXajuKEnP8mw=;
        b=Pp+3AlYJusjZBfSTsQaHM2Xm5M4anJT3JLDkUmoCPYaeFqI/NhF5MektU/U3qtQDWV
         l9GuY8qQU1YYEHRUpGlocW8XQaXQ8D8QXcmHg2/YhTcg4Qf5l/FeGUs0NZXiNGmN32mg
         Bec6I74699QJnhaA+pUkirUJzwPAUEjqlLjA6Z/vbhUvgeLqE2AoT0/icj4+HatCc5xB
         sHFZ6+iWaH3QimfEUc7uLrzCnvLRQ2H3D33STMhOK/rBF3GIiMBOWZ90s43y8EgU8mXx
         OjUV3rs+XtLB1nd27r48PL/jmwVwnaJLKvvgOhIvHtfzbr1ouY+up4sMa7yXL3oyoMnb
         A1rA==
X-Gm-Message-State: APjAAAWh8uSvimg367+2p4ml5kIPfzep1guI8Q0rjAXvMo+o6s3JpU91
        uSDNeuRHCe361NpkemaIG2iOIMf12k/k4vLWyVo=
X-Google-Smtp-Source: APXvYqzJfFXY0/MYIAEz2JMXzNxHVV+YLp9d31unGR8NMOV3+ZeODk/8PKrFstmpfvTwmDhZMSLB/7BSWw0VDNfqwzw=
X-Received: by 2002:a17:906:4d89:: with SMTP id s9mr4442266eju.268.1580393156602;
 Thu, 30 Jan 2020 06:05:56 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a50:af22:0:0:0:0:0 with HTTP; Thu, 30 Jan 2020 06:05:55
 -0800 (PST)
Reply-To: miraclegod913@gmail.com
In-Reply-To: <CAOAm71NjJWKSeKKrWB_NCvhVafVQHL-PX-YU4L4qG1wcPEKFpw@mail.gmail.com>
References: <CAOAm71MpbKSZXgiotccZuGXJVUZzVcoj_-fqzPVdOpAx+JdJKw@mail.gmail.com>
 <CAOAm71NjJWKSeKKrWB_NCvhVafVQHL-PX-YU4L4qG1wcPEKFpw@mail.gmail.com>
From:   Christy Ruth Walton <janetpenninger22@gmail.com>
Date:   Thu, 30 Jan 2020 06:05:55 -0800
Message-ID: <CAOAm71O8Xo9=oOzF=0dyV2Ta1sGzdACoW9gyKKNqK0tD7ZMscQ@mail.gmail.com>
Subject: Fwd: Hi Good Day,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Good Day,

I want to open a  Charity Foundation and  Company in your country on
your behalf  is it okay? I=E2=80=99m Christy Ruth Walton from America.
