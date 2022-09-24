Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE305E8E80
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 18:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233507AbiIXQdY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 24 Sep 2022 12:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233204AbiIXQdX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Sep 2022 12:33:23 -0400
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C126A6F573
        for <netdev@vger.kernel.org>; Sat, 24 Sep 2022 09:33:20 -0700 (PDT)
Received: by mail-io1-f70.google.com with SMTP id d24-20020a05660225d800b006a466ec7746so677123iop.3
        for <netdev@vger.kernel.org>; Sat, 24 Sep 2022 09:33:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:from:subject:message-id:in-reply-to
         :date:mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=S6Nhu5PI5Z0XvBDHUm/86UYsvskU1VKEXNdpoZG2ghw=;
        b=LtFt5Db2Fm15ZScTQepwocAVRFc3ttM5YJ04G0cQyckcibG/uFuamJJp/5PAPmy7Gq
         k85qKK/sOuOw/vt2AQlb796s9husSQUXFA+ufNgcdMuGuGlioHXU07HBuP6v8BrJGKkF
         xRQLW9MmZQSu6i7deoV0j2gZcmhg9OCjUQu9Njd5RmbyULZqCZbOgf9Pr0Tpz/X1Rs/f
         DsEu3/eP3Zw6yLmO6fnLkBj8sM4w7HwTxa7N3bIX9c1bFQklspqhdffy37VKYFHprG8V
         lyQDjjpkUZn+uk1zTeVGfG5tlrK0vshLmFKOrX8Ei6JeLbpkcXAB0y2spzoTguus/FCw
         6Sdg==
X-Gm-Message-State: ACrzQf0Wo2Jg7+2S7qVkjJv2T0zWWiw5ENJH/vwSxLmHCoLqfZWhCIl9
        hanJj3T+WjQrSjeEmkqkskLbNZEboJKte91LDSV4My0Dusj8
X-Google-Smtp-Source: AMsMyM6G82M3m2Sn/yF/jBIYC2sHRCRHmjZ3Gqt32JHmrzrNpmIrR77lh54ux3fVEhaVTxlwwbEBSl6ylYPFQbN9Ht6DCJMlw2Km
MIME-Version: 1.0
X-Received: by 2002:a92:c26f:0:b0:2f5:738d:ea72 with SMTP id
 h15-20020a92c26f000000b002f5738dea72mr6654936ild.275.1664037200125; Sat, 24
 Sep 2022 09:33:20 -0700 (PDT)
Date:   Sat, 24 Sep 2022 09:33:20 -0700
In-Reply-To: <20220924161357.33193-1-yin31149@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000034e78e05e96eda0d@google.com>
Subject: Re: [syzbot] WARNING in wireless_send_event
From:   syzbot <syzbot+473754e5af963cf014cf@syzkaller.appspotmail.com>
To:     18801353760@163.com, davem@davemloft.net, edumazet@google.com,
        johannes@sipsolutions.net, keescook@chromium.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, sfr@canb.auug.org.au,
        syzkaller-bugs@googlegroups.com, yin31149@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

failed to create VM pool: failed to create GCE image: create image operation failed: &{Code:PERMISSIONS_ERROR ErrorDetails:[] Location: Message:Required 'read' permission for 'disks/ci-upstream-linux-next-kasan-gce-root-test-job-test-job-image.tar.gz' ForceSendFields:[] NullFields:[]}.

syzkaller build log:
go env (err=<nil>)
GO111MODULE="auto"
GOARCH="amd64"
GOBIN=""
GOCACHE="/syzkaller/.cache/go-build"
GOENV="/syzkaller/.config/go/env"
GOEXE=""
GOEXPERIMENT=""
GOFLAGS=""
GOHOSTARCH="amd64"
GOHOSTOS="linux"
GOINSECURE=""
GOMODCACHE="/syzkaller/jobs/linux/gopath/pkg/mod"
GONOPROXY=""
GONOSUMDB=""
GOOS="linux"
GOPATH="/syzkaller/jobs/linux/gopath"
GOPRIVATE=""
GOPROXY="https://proxy.golang.org,direct"
GOROOT="/usr/local/go"
GOSUMDB="sum.golang.org"
GOTMPDIR=""
GOTOOLDIR="/usr/local/go/pkg/tool/linux_amd64"
GOVCS=""
GOVERSION="go1.17"
GCCGO="gccgo"
AR="ar"
CC="gcc"
CXX="g++"
CGO_ENABLED="1"
GOMOD="/syzkaller/jobs/linux/gopath/src/github.com/google/syzkaller/go.mod"
CGO_CFLAGS="-g -O2"
CGO_CPPFLAGS=""
CGO_CXXFLAGS="-g -O2"
CGO_FFLAGS="-g -O2"
CGO_LDFLAGS="-g -O2"
PKG_CONFIG="pkg-config"
GOGCCFLAGS="-fPIC -m64 -pthread -fmessage-length=0 -fdebug-prefix-map=/tmp/go-build4239397487=/tmp/go-build -gno-record-gcc-switches"

git status (err=<nil>)
HEAD detached at 380f82fb6
nothing to commit, working tree clean


go list -f '{{.Stale}}' ./sys/syz-sysgen | grep -q false || go install ./sys/syz-sysgen
make .descriptions
bin/syz-sysgen
touch .descriptions
GOOS=linux GOARCH=amd64 go build "-ldflags=-s -w -X github.com/google/syzkaller/prog.GitRevision=380f82fb6ebefdaa2b4e4f84d34a9019900f0b89 -X 'github.com/google/syzkaller/prog.gitRevisionDate=20220921-114622'" "-tags=syz_target syz_os_linux syz_arch_amd64 " -o ./bin/linux_amd64/syz-fuzzer github.com/google/syzkaller/syz-fuzzer
GOOS=linux GOARCH=amd64 go build "-ldflags=-s -w -X github.com/google/syzkaller/prog.GitRevision=380f82fb6ebefdaa2b4e4f84d34a9019900f0b89 -X 'github.com/google/syzkaller/prog.gitRevisionDate=20220921-114622'" "-tags=syz_target syz_os_linux syz_arch_amd64 " -o ./bin/linux_amd64/syz-execprog github.com/google/syzkaller/tools/syz-execprog
GOOS=linux GOARCH=amd64 go build "-ldflags=-s -w -X github.com/google/syzkaller/prog.GitRevision=380f82fb6ebefdaa2b4e4f84d34a9019900f0b89 -X 'github.com/google/syzkaller/prog.gitRevisionDate=20220921-114622'" "-tags=syz_target syz_os_linux syz_arch_amd64 " -o ./bin/linux_amd64/syz-stress github.com/google/syzkaller/tools/syz-stress
mkdir -p ./bin/linux_amd64
gcc -o ./bin/linux_amd64/syz-executor executor/executor.cc \
	-m64 -O2 -pthread -Wall -Werror -Wparentheses -Wunused-const-variable -Wframe-larger-than=16384 -Wno-stringop-overflow -Wno-array-bounds -Wno-format-overflow -static-pie -fpermissive -w -DGOOS_linux=1 -DGOARCH_amd64=1 \
	-DHOSTGOOS_linux=1 -DGIT_REVISION=\"380f82fb6ebefdaa2b4e4f84d34a9019900f0b89\"



Tested on:

commit:         aaa11ce2 Add linux-next specific files for 20220923
git tree:       linux-next
kernel config:  https://syzkaller.appspot.com/x/.config?x=186d1ff305f10294
dashboard link: https://syzkaller.appspot.com/bug?extid=473754e5af963cf014cf
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=15585edf080000

