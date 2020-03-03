Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECDD31769CA
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 02:03:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbgCCBDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 20:03:16 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:44425 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726816AbgCCBDQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 20:03:16 -0500
Received: by mail-pl1-f196.google.com with SMTP id d9so508083plo.11;
        Mon, 02 Mar 2020 17:03:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=V9I0/Xqg/ShdZNC+4R9RH/azMp7x4BOJw5weGOiqwCQ=;
        b=BCz91v6Dd2ZhMz05lk0QRgFka5Gx70OtA7cscXAuUksyQ/59dnSMvKMrnuG33kw3W/
         Ip97+dWlhsiwjIxbuR38PtatUEUv0Ue3U4EtUdYR2OmZIS523Jf4Jq/zer0l1gT4a8e0
         R9tJDxNrmOnm8uoB1bHBjR2RC7kRiUmQsqESOGYXBZkvNinkGt1iYHU6eu7Dsvml7oQI
         h7R/Pgg/hLx3jdR1uqd3b2NJ03raxbSlnE4uW88dV0qjO1inllhDzBXEiE0WwgZBWPRa
         hOq0+EM26Svv34XKIXxQpoGzevNSv7EQo06VBFJvxGKV44yFH01Hb45tX1SzcUYj4L24
         2IRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=V9I0/Xqg/ShdZNC+4R9RH/azMp7x4BOJw5weGOiqwCQ=;
        b=UFZZ3wiwgDttcRnN3Hz8U0iq+fXRNPrU82vsV2eh0ZgEqhadpqDi4oYEoch6YGMieh
         +SfIJ0dEBhgGufTRmitxD4U0dDLlzFSPv9ApHvnchPIdo0vx7aDNg98HiCoY09iv/n69
         afJFxJf+ySRYLad7e2cw5JvvMKSDSlUUKX1xxripNuuUfDYyfGTn81soxYLGYN3rAHed
         ACIXfN1pmneg8SuRsI7iM05o4DseaLga3j7Ny/ugvjHkdJ+3rUT2yDN2osbO/Xy2ssNm
         aHzdA+B3rZweHVOmtI4GIYTMVVzpsArOKlNKxA0/daC5zqpqX+Zez699UB/xnAhqY4GU
         IFbg==
X-Gm-Message-State: ANhLgQ3+dfEAzmDSLDZM+hCuY/997DThKmseNl1ttGfg3Y7dt5AQXFCR
        UkQWKV4BWcMrD4tHOWt5DAs=
X-Google-Smtp-Source: ADFU+vv4poLC7xRKXHOhSUU2AM+HSCwU0wAZ+XPBXsYZAtCV5UyJVuykrQmAzpmr3O22N56KJkp3EQ==
X-Received: by 2002:a17:902:d88d:: with SMTP id b13mr1676511plz.228.1583197395298;
        Mon, 02 Mar 2020 17:03:15 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:500::7:1db6])
        by smtp.gmail.com with ESMTPSA id d186sm3951901pfc.8.2020.03.02.17.03.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Mar 2020 17:03:14 -0800 (PST)
Date:   Mon, 2 Mar 2020 17:03:12 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     daniel@iogearbox.net, ast@fb.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Andrey Ignatov <rdna@fb.com>
Subject: Re: [PATCH bpf] selftests/bpf: Declare bpf_log_buf variables as
 static
Message-ID: <20200303010311.bg6hh4ah5thu5q2c@ast-mbp>
References: <20200302145348.559177-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200302145348.559177-1-toke@redhat.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 02, 2020 at 03:53:48PM +0100, Toke Høiland-Jørgensen wrote:
> The cgroup selftests did not declare the bpf_log_buf variable as static, leading
> to a linker error with GCC 10 (which defaults to -fno-common). Fix this by
> adding the missing static declarations.
> 
> Fixes: 257c88559f36 ("selftests/bpf: Convert test_cgroup_attach to prog_tests")
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>

Applied to bpf-next.
It's hardly a fix. Fixes tag doesn't make it a fix in my mind.
I really see no point rushing it into bpf->net->Linus's tree at this point.
