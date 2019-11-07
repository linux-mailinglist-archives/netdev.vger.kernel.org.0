Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A85ECF365C
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 18:55:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389919AbfKGRza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 12:55:30 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:34833 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730510AbfKGRza (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 12:55:30 -0500
Received: by mail-lj1-f196.google.com with SMTP id r7so3290713ljg.2;
        Thu, 07 Nov 2019 09:55:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/5nhtXZ2avAcpZmHobzdQpLgt/NcDOLxRfXhUvIqUGs=;
        b=NUITiYadCszrQMXfzKbwqJsfAB7EiMlhUvACmf/vVP7PgzUntqyV9t7AeVQbSEswB2
         fcdLMnXv06twf87jXeYdbTSHuRl1FnAdRVuaLTRevBGqkslwQ6/CdCO0F4k3lTCrbcxC
         LVXfXmwf/e1UNXdMwsopoKWpdeSRWV1FC0YefWLFAm2Qfg9FPEtdrof8pnhvASAKLJzd
         CEo1Ri7FxSjcPpay6BNUQFWZB4+j1ynE/pz9bEQd1j9cJjfJK0763dMaU4IjSvhWB7wM
         tZX/deBhLrEm3afOmQ/yC58NOMSfyGNsSlh9u0T8oA6nYhi+QUFopVUIO8TQ5hJir3ce
         TCzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/5nhtXZ2avAcpZmHobzdQpLgt/NcDOLxRfXhUvIqUGs=;
        b=A6wDcolLA7FGQ8KuDeBXmEkk5ht9sC26TkVxTbLTsACZyU4DIC2+bNpa7N4H6HnIxm
         aV7k/OEWzOCq3MKzyxFrZYVni9SllOh9PDGrkF4fXVuyA56XRgqLvbGwKP6w71dNo4D6
         Qz3qc4dzcGueK4nYAwlx+7lM7HK0Kpeo+DlfGM6gO1mQfzn26elqYcn6RZ/8H0fT5EBS
         11YOrDob90XcahvTHYtIBxlj2+z2UdHFKKQovppcme9JkvLIroYdHOFpIHXiyL86sVs/
         Qrzuk7srXpf9Phuvpw0ek5ARGZDoVSQErK/5iS/dDANpa1CSauw8uvNKrAtgGu8qpIr6
         NcRA==
X-Gm-Message-State: APjAAAWGrrGvVQXIYbAcQXvQv1EOfDlIbJ78lIXHSTBZf/jy7ZPUm7EM
        jJH2/AI6xqwM+GvvuZemXzJE7A68GCrgKua7kow=
X-Google-Smtp-Source: APXvYqwBA6+DPvibzaIBlFeMZph4+PSjxelMjq5bTm4yVglUCH9/bQ6KJMfHYhOTY+00WnLq+8YbO214UQBI99J0UYQ=
X-Received: by 2002:a2e:6e15:: with SMTP id j21mr3369234ljc.17.1573149328066;
 Thu, 07 Nov 2019 09:55:28 -0800 (PST)
MIME-Version: 1.0
References: <20191107125224.29616-1-anders.roxell@linaro.org> <20191107125224.29616-2-anders.roxell@linaro.org>
In-Reply-To: <20191107125224.29616-2-anders.roxell@linaro.org>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Thu, 7 Nov 2019 09:55:16 -0800
Message-ID: <CAPhsuW6oL-RvTfqk6Gh5wAhfx1Br1evxEH+TkmDkSOWftirQnQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] selftests: bpf: test_tc_edt: add missing object file
 to TEST_FILES
To:     Anders Roxell <anders.roxell@linaro.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 7, 2019 at 4:53 AM Anders Roxell <anders.roxell@linaro.org> wrote:
>
> When installing kselftests to its own directory and running the
> test_tc_edt.sh it will complain that test_tc_edt.o can't be find.
>
> $ ./test_tc_edt.sh
> Error opening object test_tc_edt.o: No such file or directory
> Object hashing failed!
> Cannot initialize ELF context!
> Unable to load program
>
> Rework to add test_tc_edt.o to TEST_FILES so the object file gets
> installed when installing kselftest.
>
> Fixes: 74b5a5968fe8 ("selftests/bpf: Replace test_progs and test_maps w/ general rule")
> Signed-off-by: Anders Roxell <anders.roxell@linaro.org>

Acked-by: Song Liu <songliubraving@fb.com>
