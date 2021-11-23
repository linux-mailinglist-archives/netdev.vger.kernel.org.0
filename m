Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8605145A9C5
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 18:13:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238991AbhKWRQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 12:16:38 -0500
Received: from mailsec210.isp.belgacom.be ([195.238.22.106]:59510 "EHLO
        mailsec210.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237703AbhKWRQi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 12:16:38 -0500
X-IPAS-Result: =?us-ascii?q?A2DxBQCbIJ1h/y4FIwpaHgENLwwOCwmFUHeEPJBunl8LA?=
 =?us-ascii?q?QEBAQEBAQEBRwECBAEBhHoKUwWCHQElOBMBAgQBAQEBAwIDAQEBAQEBAwEBB?=
 =?us-ascii?q?gEBAQEBAQUEAYEbhS9GgjUig24nFUEYHQImAmCFZSqvSYExgQGIUoEmgRAqi?=
 =?us-ascii?q?iqES4FJRIFIAYF1gT+BBQGGV4JlBJAqCII5fUKgX54lg0SfAwUtg2ySEpEvL?=
 =?us-ascii?q?ZVoH4Iio3UBgXRPgS5tGIMlUBcRjjeOOkNoAgYLAQEDCYI6gygIjDIBgQ8BA?=
 =?us-ascii?q?Q?=
IronPort-PHdr: A9a23:rh/2chat6dnzvyTSTVJwl9j/LTEg14qcDmcuAnoPtbtCf+yZ8oj4O
 wSHvLMx1gaPAduQuq0MotGVmpioYXYH75eFvSJKW713fDhBt/8rmRc9CtWOE0zxIa2iRSU7G
 MNfSA0tpCnjYgBaF8nkelLdvGC54yIMFRXjLwp1Ifn+FpLPg8it2O2+5YDfbx9HiTe8br9/K
 Be7phjNu8cLhodvNrw/wQbTrHtSfORWy2JoJVaNkBv5+8y94p1t/TlOtvw478JPXrn0cKo+T
 bxDETQpKHs169HxtRnCVgSA+H0RWXgLnxVSAgjF6Bb6Xortsib/q+Fw1jWWMdHwQLspXzmp8
 qVlRwLyiCofKTA383zZhcNsg6xUrh2hphxxzYDPbYGJNvdzZL/Rcc8ASGdDWMtaSixPApm7b
 4sKF+cPPfxXoJL8p1QUqxuxHQmiBPn1zTBVnHj2x6w63PgiEQrb2wEgEcgBv2/arNjuL6cSU
 uC0zK/WwjXfdf9Zwiny5ZHOfxs8rv6CQah+ftDNyUkzCQzFlFOQpJTlMj2V0ukAr2iV4ut9W
 e+ylWMqtgV8rzqry8oxjoTFmp8ZxkzE+Chl3oo4O9m1Rk5/bNCqEJVdsyWXOYRqT84sRWxjp
 SU0yqUetJKmYCQG0poqyh7FZ/GHaYSF7RPuWP6VLDtlnn5pZbCyihWo/US+1uHxWdO43VJKo
 ydDj9LCrGoC1wbJ5ciCUvZ9+0Ch1iuR2A3L8eFEJFw0lbLcK5483r48jpoTvlrHHi/xgEj2i
 bWZdkQg+umm9evoeanqqoOSOoNtkQH+LLghltS+AeQ+LAcOQ3CW9fmg2LH580D0QK9Gg/0sn
 qTWsZ3WPcEbqbS4Aw9R3IYj8RG/DzK+3dQWh3YIN1xFdQmcj4jqO1DOJu73Deulj1u3jjhn3
 +rGMaH5ApXRMnjDl6/scqtn5E5C1gUzyMtS6I9OBbEfPv3zX0vxtNvWDh8lKQC0xfjoCMll3
 IMERW2PGrOZML/VsVKQ5eIvPvKDa5UOtTb+Nfcl/fjugmE9mVMHeqmpx5QXYmiiHvt6O0WZf
 WbsgtAZHGcRpQU+Vu3qiEODUT5UfHuyRbwz6Sw7CI28EYfPXJyigLuE3C2jBJ1ZenhGCkyQE
 Xfvb4iEWewDZzyUIsB9iTEET6auRJIh1R60qA/20aZoLu3R+icAr5LsyMB15/HPlRE17TF0C
 dqS032QQG5qgGMFXCE23K9hrkxn0FuD0rZ3g+ZeFdNN4/NFSAA6NYTTz+ZiEdD9RhrBfsuVS
 FahWtimBTAxTtQsw94Bekp9GMutjgrF3yW0B78YjKKLBJMq/aLGxXTxJNhyy2zA1KY/i1kqW
 MxPNXephv03yw+GC4fXnkCxm6+0eKEY2yDRsmGO0S7Gv1xSWSZzXL/DUHRZYVHZ6Zzi7FnDU
 b6pIa4qPgtI1YiJLa4OIt/jgFNNbO3uNNTXfyS6nGLjKwyPw+aiZYDrcmMq8j9cBMkekgsQt
 SKIPAIwLjyismTTEHpkGAS8MAvX7eBipSbjHQcPxAaQYhg5v4c=
IronPort-Data: A9a23:nKLKhqulZrlIxv5DU2JtEn0KeefnVDhfMUV32f8akzHdYApBsoF/q
 tZmKWyBPvmNYmD8KdhyPIS19k8B7MWBzdIwQQM/qC9jECIXgMeUXt7xwmUcn8+xwmwvaGo9s
 q3yv/GZdJhcokf0/0vrav64xZVF/fngqoDUUYYoAQgsA187IMsdoUg7wbdg29Qz2YPR7z6l4
 LseneWOYDdJ5BYpagr424rbwP+4lK2v0N+wlgVWicFj5DcypVFMZH4sDf3Zw0/Df2VhNrXSq
 9AvY12O1jixEx8FUrtJm1tgG6EAaua60QOm0hK6V0U+6/RPjnRa70o1CBYTQVxLgQmoocpQ8
 c9ivsScZAgYIfD2outIBnG0EwkmVUFH0LrOIHygvMbLlxaDaGXnqxlsJBhue9ZFvLsxXT8mG
 f8wcVjhajiNjui46Km4W+9hmoIpIaEHOatG4Sw+nW+BXZ7KR7ifT4zG+/1I3w413J9sDPGEd
 /ojTDNGOUGojxpnfw1/5IgFtOuhmHT6WzFRtl+Qoa05/y7VwRAZ+LvwOtP9edGQQ8hR2EGCq
 Qru5G7jAw8bM/SFxDaF+27qjejK9Qv5Uo8UH5Wi+/JqiUHVzWsWYDUQWEe3rOeRlEGzQZRcJ
 lYS9y5oqrI9nGSvT9/gT1i7rWSCsxo0RdVdCas55RuLx66S5ByWblXoVRZEYd0iq8I8HWRxk
 EOC2djuHyQHXKCpdE9xP4y89VuaURX550dYDcPYZWPpKOUPbG3+Ytwjgzqj/GOIYgXJJAzN
IronPort-HdrOrdr: A9a23:r2xIbq4cOK6/8IiaKgPXwODXdLJyesId70hD6qkRc202TiX8ra
 uTdZsguCMc5Ax8ZJhYo6H6BEDYewKlyXcX2/hzAV7BZmjbUQKTRekJ0WKF+VLd8kbFltK1u5
 0PT0EwMqyVMbE/t7ed3OGEe+xQpeVuz8iT9J7jJ1UEd3AMV51d
X-IronPort-Anti-Spam-Filtered: true
Received: from mailweb003.tc.corp (HELO mailweb003-svc) ([10.35.5.46])
  by privrelay.glb.bgc.bc with ESMTP; 23 Nov 2021 18:13:26 +0100
Received: from [91.178.204.95]
        by webmail.ux.proximus.be with HTTP; Tue, 23 Nov 2021 18:13:26 +0100
To:     davem@davemloft.net, kuba@kernel.org, sbrivio@redhat.com,
        jbenc@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <1ad77777.15fd.17d4dc9bd96.Webtop.157@skynet.be>
Subject: vxlan: Possible regression in vxlan_rcv()
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed; delsp=no
Content-Transfer-Encoding: 7bit
User-Agent: OWM Mail 3
X-SID:  157
X-Originating-IP: [91.178.204.95]
From:   =?UTF-8?Q?Fabian_Fr=C3=A9d=C3=A9rick?= <fabf@skynet.be>
Date:   Tue, 23 Nov 2021 18:13:26 +0100 (CET)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

    Last year I sent the following

2ae2904b5bac
("vxlan: don't collect metadata if remote checksum is wrong")


thinking it was an optimization and noticed it was managed in that order 
before patch

f14ecebb3a4e
("vxlan: clean up extension handling on rx")


    I was not able to create some script to test that code and had no 
feedback on it but lately, looking at it again I noticed that metadata 
sequence (if (vxlan_collect_metadata(vs))) was updating skb in 
skb_dst_set(skb, (struct dst_entry *)tun_dst); which was not the case 
during the clean up above.

   Can someone tell me if the update is really ok or how I could check 
that code ?
if VXLAN_F_REMCSUM_RX involves metadata checking I can ask to remove the 
patch.

Best regards,
Fabian
