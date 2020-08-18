Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCCE5247FA5
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 09:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgHRHo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 03:44:56 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:12512 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726043AbgHRHoy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 03:44:54 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07I7WH3u078620;
        Tue, 18 Aug 2020 03:44:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=vb/0Lv/Oag+j2at5HWX3FDglJmMlf/hgAHnOXhZd5Is=;
 b=H+AEfx5RF0HMlLW6p9yqpqnPvYkU20JfVq+BTgaMWYyBcxMamxplMvWXKPFu8yZHewdD
 z10TAYhP2DBLR1ds5Iz5HCxPOS8/pdSrIWb21jwNc8ksdDFWWM8DecmmBvgRbdVVCG9N
 4+SZ5PxP/bxoPIPQdE3FvZ5L5RhxLv/+l9hr1scy+ZfeasbeqOGWqv5jMngNiMRPIVWJ
 QdnZowwGsAs2MUIPtFsm/lrhTA4J9lLrTOT0eQ4P3LcHFjqIuQuQd/mUXLRgEM+a3YQ4
 deLtqvzQ8KU728X/bc1m0WBfsgmIyUD1hsDBRykT0GfT8303MN2mtfPecEQ9FqCtm2li aw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3304tdrg9t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Aug 2020 03:44:39 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07I7ZaJS088312;
        Tue, 18 Aug 2020 03:44:39 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3304tdrg99-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Aug 2020 03:44:39 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07I7awnD032364;
        Tue, 18 Aug 2020 07:44:37 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3304c9078k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Aug 2020 07:44:36 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07I7iYvl55771474
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 07:44:34 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1EE1E52051;
        Tue, 18 Aug 2020 07:44:34 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.199.54.96])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id C5BD45204F;
        Tue, 18 Aug 2020 07:44:30 +0000 (GMT)
Message-ID: <5a60f3a139b80a3aa641e6d80f4ed923872926ff.camel@linux.ibm.com>
Subject: Re: [PATCH bpf] selftest/bpf: make bpftool if it is not already
 built
From:   Balamuruhan S <bala24@linux.ibm.com>
To:     Yonghong Song <yhs@fb.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        naveen.n.rao@linux.vnet.ibm.com, ravi.bangoria@linux.ibm.com,
        sandipan@linux.ibm.com, kafai@fb.com, songliubraving@fb.com,
        andriin@fb.com, john.fastabend@gmail.com, kpsingh@chromium.org
Date:   Tue, 18 Aug 2020 13:14:29 +0530
In-Reply-To: <2190c03e-fb9b-7dc3-bfa1-7d289d6b68b1@fb.com>
References: <20200814085756.205609-1-bala24@linux.ibm.com>
         <2190c03e-fb9b-7dc3-bfa1-7d289d6b68b1@fb.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.3 (3.34.3-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-18_04:2020-08-18,2020-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 priorityscore=1501 phishscore=0 spamscore=0 impostorscore=0 suspectscore=0
 mlxscore=0 clxscore=1015 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180049
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-08-14 at 09:01 -0700, Yonghong Song wrote:
> 
> On 8/14/20 1:57 AM, Balamuruhan S wrote:
> > test_bpftool error out if bpftool is not available in bpftool dir
> > linux/tools/bpf/bpftool, build and clean it as part of test
> > bootstrap and teardown.
> > 
> > Error log:
> > ---------
> > test_feature_dev_json (test_bpftool.TestBpftool) ... ERROR
> > test_feature_kernel (test_bpftool.TestBpftool) ... ERROR
> > test_feature_kernel_full (test_bpftool.TestBpftool) ... ERROR
> > test_feature_kernel_full_vs_not_full (test_bpftool.TestBpftool) ... ERROR
> > test_feature_macros (test_bpftool.TestBpftool) ... ERROR
> > 
> > ======================================================================
> > ERROR: test_feature_dev_json (test_bpftool.TestBpftool)
> > ----------------------------------------------------------------------
> > Traceback (most recent call last):
> >    File
> > "/home/ubuntu/disk/linux/tools/testing/selftests/bpf/test_bpftool.py",
> >      return f(*args, iface, **kwargs)
> >    File
> > "/home/ubuntu/disk/linux/tools/testing/selftests/bpf/test_bpftool.py",
> >      res = bpftool_json(["feature", "probe", "dev", iface])
> >    File
> > "/home/ubuntu/disk/linux/tools/testing/selftests/bpf/test_bpftool.py",
> >      res = _bpftool(args)
> >    File
> > "/home/ubuntu/disk/linux/tools/testing/selftests/bpf/test_bpftool.py",
> >      return subprocess.check_output(_args)
> >    File "/usr/lib/python3.8/subprocess.py", line 411, in check_output
> >      return run(*popenargs, stdout=PIPE, timeout=timeout, check=True,
> >    File "/usr/lib/python3.8/subprocess.py", line 489, in run
> >      with Popen(*popenargs, **kwargs) as process:
> >    File "/usr/lib/python3.8/subprocess.py", line 854, in __init__
> >      self._execute_child(args, executable, preexec_fn, close_fds,
> >    File "/usr/lib/python3.8/subprocess.py", line 1702, in _execute_child
> >      raise child_exception_type(errno_num, err_msg, err_filename)
> > FileNotFoundError: [Errno 2] No such file or directory: 'bpftool'
> > 
> > Signed-off-by: Balamuruhan S <bala24@linux.ibm.com>
> > ---
> >   tools/testing/selftests/bpf/test_bpftool.py | 13 +++++++++++++
> >   1 file changed, 13 insertions(+)
> > 
> > diff --git a/tools/testing/selftests/bpf/test_bpftool.py
> > b/tools/testing/selftests/bpf/test_bpftool.py
> > index 4fed2dc25c0a..60357c6891a6 100644
> > --- a/tools/testing/selftests/bpf/test_bpftool.py
> > +++ b/tools/testing/selftests/bpf/test_bpftool.py
> > @@ -58,12 +58,25 @@ def default_iface(f):
> >       return wrapper
> >   
> >   
> > +def make_bpftool(clean=False):
> > +    cmd = "make"
> > +    if clean:
> > +        cmd = "make clean"
> > +    return subprocess.run(cmd, shell=True, cwd=bpftool_dir, check=True,
> > +                          stdout=subprocess.DEVNULL)
> > +
> >   class TestBpftool(unittest.TestCase):
> >       @classmethod
> >       def setUpClass(cls):
> >           if os.getuid() != 0:
> >               raise UnprivilegedUserError(
> >                   "This test suite needs root privileges")
> > +        if subprocess.getstatusoutput("bpftool -h")[0]:
> > +            make_bpftool()
> > +
> > +    @classmethod
> > +    def tearDownClass(cls):
> > +        make_bpftool(clean=True)
> 
> I think make_bpftool clean should only be called if the make actually
> triggered during setUpClass, right?

yes, I will fix it in the next version.

> 
> >   
> >       @default_iface
> >       def test_feature_dev_json(self, iface):
> > 
> > base-commit: 6e868cf355725fbe9fa512d01b09b8ee7f3358f0
> > 

